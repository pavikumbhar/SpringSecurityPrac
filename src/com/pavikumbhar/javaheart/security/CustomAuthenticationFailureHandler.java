/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pavikumbhar.javaheart.security;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import org.springframework.web.servlet.LocaleResolver;

/**
 *
 * @author pravinkumbhar
 */
@Component("authenticationFailureHandler")
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Autowired
    private MessageSource messages;

    @Autowired
    private LocaleResolver localeResolver;
    
    

    @Override
    public void onAuthenticationFailure(final HttpServletRequest request, final HttpServletResponse response, final AuthenticationException exception) throws IOException, ServletException {
        setDefaultFailureUrl("/login?error=true");

        super.onAuthenticationFailure(request, response, exception);

        final Locale locale = localeResolver.resolveLocale(request);
        
        String ip="";
        final String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            ip= request.getRemoteAddr();
        }else{
              ip= xfHeader.split(",")[0];
        }
      

     //   String errorMessage = messages.getMessage("message.badCredentials", null, locale);
String errorMessage=null;

System.out.println("getClientIP  " + ip);
        System.out.println("errorMessage  " + errorMessage);
        System.out.println("exception >>>>>>  " + exception.getClass().getName());
        System.out.println("exception.getMessage() >>>>>>  " + exception.getMessage());
          System.out.println("exception >>>>>>  " + (exception instanceof org.springframework.security.core.userdetails.UsernameNotFoundException));

        if (exception.getMessage() != null) {
            if (exception.getMessage().equalsIgnoreCase("User account is locked")) {
                errorMessage = messages.getMessage("auth.message.disabled", null, locale);
            } else if (exception.getMessage().equalsIgnoreCase("User account has expired")) {
                errorMessage = messages.getMessage("auth.message.expired", null, locale);
            } else if (exception.getMessage().equalsIgnoreCase("User credentials have expired")) {
                
                errorMessage = messages.getMessage("auth.message.blocked", null, locale);
            } else if (exception.getMessage().equalsIgnoreCase("Bad credentials")) {
                errorMessage = messages.getMessage("auth.message.expired", null, locale);
               errorMessage=" Bad credentials";
            }
            else if (exception.getMessage().equalsIgnoreCase("No user found with username")) {
              //  errorMessage = messages.getMessage("auth.message.expired", null, locale);
               errorMessage="No user found with username";
            }
            
        }
        
        System.out.println("(exception.getClass() == InternalAuthenticationServiceException  " + (exception.getClass() == InternalAuthenticationServiceException.class));
       
        		System.out.println("isAssignableFrom  " + exception.getClass().isAssignableFrom(UsernameNotFoundException.class));
        request.getSession().setAttribute(WebAttributes.AUTHENTICATION_EXCEPTION, errorMessage);
    }
    
   
}

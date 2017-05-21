/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pavikumbhar.javaheart.security;

import com.pavikumbhar.javaheart.entity.Role;
import com.pavikumbhar.javaheart.entity.User;
import com.pavikumbhar.javaheart.service.UserService;
import java.util.HashSet;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author pravinkumbhar
 */
@Service("userDetailsService")
@Transactional
public class CustomUserDetailsService implements org.springframework.security.core.userdetails.UserDetailsService {

    @Autowired
    private UserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

       // User user = new User();
        User user =userService.findByUsername(username);
        //user.setUsername("pravin");
        //user.setLocked(true);

        try {
         
            if (user == null) {
                 throw new UsernameNotFoundException("Not Exist User");
            }
   /*
            if (user.isEnabled() == false) {
                System.out.println("User not enabled");

                throw new DisabledException("User not enabled");
            }

            if (user.isLocked() == true) {
               // System.out.println("User is Locked");

                throw new LockedException("blocked");
            }
            if (user.isPasswordExpired() == true) {
                // System.out.println("Password Expired");

                throw new CredentialsExpiredException("User account has expired");
            }
*/
            Set<GrantedAuthority> grantedAuthorities = new HashSet<GrantedAuthority>();
            for (Role role : user.getRoles()) {
                grantedAuthorities.add(new SimpleGrantedAuthority(role.getName()));
            }
//String username,
//String password, 
//boolean enabled, 
//boolean accountNonExpired, 
//boolean credentialsNonExpired, 
//boolean accountNonLocked, 
//Collection<? extends GrantedAuthority> authorities) {
            return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), user.isEnabled() ,user.isExpired() ,user.isPasswordExpired(),user.isLocked(),grantedAuthorities);
        } catch (final Exception e) {
            throw new RuntimeException(e);
        }
    }

}

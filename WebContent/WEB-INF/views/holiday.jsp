
<section id="main-content">
    <section class="wrapper site-min-height">
        <h3><i class="fa fa-angle-right"></i> <i class="fa fa-calendar fa-2x"></i>Holiday </h3>
        <div class="row mt">
            <div class="col-lg-12">

                <!--          		<p>Place your content here.</p>-->

                     <div class="content-panel">

                            <h4><i class="fa fa-angle-right"></i>Holiday calendar</h4>
                            <section id="unseen">

                               <div class=" col-lg-offset-1" id="myDatePicker" > </div>

                            </section>
                        </div><!-- /content-panel -->


            </div>
        </div>
        
         


    </section><! --/wrapper -->
</section>
<style type="text/css">

    /* @group Blink */
    .blink {
        -webkit-animation: blink .75s linear infinite;
        -moz-animation: blink .75s linear infinite;
        -ms-animation: blink .75s linear infinite;
        -o-animation: blink .75s linear infinite;
        animation: blink .75s linear infinite;
    }
    @-webkit-keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 1; }
        50.01% { opacity: 0; }
        100% { opacity: 0; }
    }
    @-moz-keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 1; }
        50.01% { opacity: 0; }
        100% { opacity: 0; }
    }
    @-ms-keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 1; }
        50.01% { opacity: 0; }
        100% { opacity: 0; }
    }
    @-o-keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 1; }
        50.01% { opacity: 0; }
        100% { opacity: 0; }
    }
    @keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 1; }
        50.01% { opacity: 0; }
        100% { opacity: 0; }
    }
    /* @end */

</style>


<style type="text/css">
    .ui-datepicker td.holiday a, .ui-datepicker td.holiday a:hover {
        background: none #FFEBAF;
        border: 1px solid #BF5A0C;
        color:red;

    }
    .ui-datepicker {
        width: 900px !important;
    }

    .event a {
        background-color: #42B373 !important;
        background-image :none !important;
        color: #ffffff !important;
    }

    /*                                                .ui-datepicker-week-end, .ui-datepicker-week-end a.ui-state-default {color:red;}*/
</style>

<script type="text/javascript">


    $(function () {

        holidays();

    });

    function holidays() {

        // array to store holiday list      
        var holidaylist = [];

        // get all holidaylist from db
        function getHolidays(year) {


            alert('Inside ajax getHolidays method [][]' + year),
                    $.ajax({
                        type: 'GET',
                        url: 'getHolidayList',
                        data: {'year': year},
                        contentType: 'application/json; charset=utf-8',
                        async: false, //while this is not generally good practice, it works here
                        success: function (data) {


                            //   alert('holidays marked----->' + data);
                            for (i = 0; i < data.length; i++)
                            {
                                holidaylist.push(new Date((data[i])));

                            }
                            alert('dates in array of holidays---->' + holidaylist);

                        }

                    });
        }


        //date picker function to show calender
        $("#myDatePicker").datepicker({
            // The hidden field to receive the date
            altField: "#dateHidden",
            // The format you want
            // altFormat: "yyyy-mm-dd",
            // The format the user actually sees
            dateFormat: "dd-M-yy",
            numberOfMonths: [3, 4],
            //numberOfMonths: 12,
            stepMonths: 12,
            defaultDate: new Date(new Date().getFullYear(), 0, 1),
            // showCurrentAtPos: new Date().getMonth
            beforeShow: getHolidays(new Date().getFullYear()),
            onChangeMonthYear: function (year) {

                alert('selected date: ' + year);
                holidaylist.splice(0, holidaylist.length);
                getHolidays(year);
            },
            onSelect: function (date) {

              //  var aDate = new Date(date);
                 var dateSplit = date.split("-");            
               var aDate = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);

                var d = aDate.getDate();
                var day = aDate.getDay();
                var offset = (((1 + aDate.getDay() - d) % 7) + 7) % 7;
                alert("[date]"+date);
                alert("[day]"+day);
                
               
                $(this).change();

                var cnt = 0;

                for (i = 0; i < holidaylist.length; i++)
                {

                    if (holidaylist[i].getTime() === aDate.getTime())
                    {

                        cnt++;

                    }

                }
                if (day === 0 || (!((offset + d) % 14)))
                {
                    alert("It's Holiday...");
                } else if (cnt === 0)
                {
                    var retVal = confirm("Do you want to add holiday ?");
                    if (retVal === true)
                    {
                        setHolidays(date);
                        alert("Holiday Added " + date);
                    } else
                    {
                        alert("Holiday NOT Added ");
                    }
                }  //else if (day === 0&&(day === 6 && (!((offset + d) % 14)))) {
                else
                {
                    alert("It's Holiday...");

                    if (day !== 0 || (!((offset + d) % 14)))
                    {
                        var result = confirm("Do you want to remove holiday ?");
                        if (result === true)
                        {
                            for (i = 0; i < holidaylist.length; i++)
                            {

                                if (holidaylist[i].getTime() === aDate.getTime())
                                {

                                    holidaylist.splice(i, holidaylist[i]);

                                    break;

                                }

                            }
                            updateHoliday(date);
                            // alert("Date Updated " + date);
                        }
                    }
                }
                return true;

            },
            beforeShowDay: is2ndOr4thSat_2

        });

// mark holday
        function is2ndOr4thSat_2(date) {
            var d = date.getDate();
            var day = date.getDay();
            var offset = (((1 + date.getDay() - d) % 7) + 7) % 7;
            //return !((offset + d) % 14);
           

            for (i = 0; i < holidaylist.length; i++)
            {

                if (holidaylist[i].getTime() === date.getTime())
                {

                    return [true, 'holiday', 'Holiday'];
                }

            }

            if (day === 0)
            {
                //alert("inside conditon 2....");
                return [true, 'holiday', 'Sunday'];

            } else if (day === 6 && (!((offset + d) % 14)))
            {
                // alert("inside conditon 3....");
                return [true, 'holiday', 'Saturday'];
            } else
            {
                // alert("inside conditon final....");
                return [true, ''];
            }

        }



        //mark holidays with different css
        function markHolidays(date) {


            var day = date.getDay();
            week = Math.floor(date.getDate() / 7);

            for (i = 0; i < holidaylist.length; i++)
            {

                if (holidaylist[i].getTime() === date.getTime())
                {

                    return [true, 'holiday', 'Holiday'];
                }

            }

            if (day === 0)
            {
                //alert("inside conditon 2....");
                return [true, 'holiday', 'Sunday'];

            } else if (day === 6 && ((week === 1 || week === 3)))
            {
                // alert("inside conditon 3....");
                return [true, 'holiday', 'Saturday'];
            } else
            {
                // alert("inside conditon final....");
                return [true, ''];
            }



        }


        //function to add new holiday
        function setHolidays(date) {

            alert('Inside ajax set call function >>>' + date);

            $.ajax({
                type: 'GET',
                url: 'setHoliday',
                data: {'date': date},
                contentType: 'application/json; charset=utf-8',
                async: false, //while this is not generally good practice, it works here                       
                success: function (resp) {

                    holidaylist.splice(0, holidaylist.length);
                    
                     var dateSplit = date.split("-");            
                     var aDate = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
                  //  getHolidays(new Date(date).getFullYear());
                    getHolidays(aDate.getFullYear());
                    

                }

            });



        }


        //remove selected holiday   
        function updateHoliday(date) {

              alert('Inside ajax update call function ---->' + date);

            $.ajax({
                type: 'GET',
                url: 'updateHoliday',
                data: {'date': date},
                contentType: 'application/json; charset=utf-8',
                async: false, //while this is not generally good practice, it works here                       
                success: function (resp) {
                    holidaylist.splice(0, holidaylist.length);
                    
                    var dateSplit = date.split("-");            
                     var aDate = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
                  //  getHolidays(new Date(date).getFullYear());
                    getHolidays(aDate.getFullYear());

                }

            });



        }


    }


</script>




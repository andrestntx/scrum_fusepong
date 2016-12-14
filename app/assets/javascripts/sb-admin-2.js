/*!
 * Start Bootstrap - SB Admin 2 v3.3.7+1 (http://startbootstrap.com/template-overviews/sb-admin-2)
 * Copyright 2013-2016 Start Bootstrap
 * Licensed under MIT (https://github.com/BlackrockDigital/startbootstrap/blob/gh-pages/LICENSE)
 */
$(document).ready(function() {
    $('#side-menu').metisMenu();
    
    $('.datepicker').datepicker({
        format: "yyyy-mm-dd"
    });
    
    $('.datepicker-multiple').datepicker({
        format: "yyyy-mm-dd",
        multidate: true
    });

    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay',
        },
        editable: false,
        defaultView: "agendaWeek",
        firstDay: 1,
        events: "/developer/users/" + $("#calendar").attr("data-userid") + "/calendar",
        eventClick: function(calendarEvent, jsEvent, view) {
            drawCalendarEvent(calendarEvent);
        }

    });

    $('#sprint-calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay',
        },
        editable: false,
        defaultView: "month",
        firstDay: 1,
        events: "/developer/projects/" + $("#sprint-calendar").attr("data-projectid") + "/sprints/" + $("#sprint-calendar").attr("data-sprintid") + "/calendar",
        eventClick: function(calendarEvent, jsEvent, view) {
            drawCalendarEvent(calendarEvent);    
        }
    }); 

    $(window).bind("load resize", function() {
        var topOffset = 50;
        var width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        var height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
    });

    var url = window.location;
    // var element = $('ul.nav a').filter(function() {
    //     return this.href == url;
    // }).addClass('active').parent().parent().addClass('in').parent();
    var element = $('ul.nav a').filter(function() {
        return this.href == url;
    }).addClass('active').parent();

    while (true) {
        if (element.is('li')) {
            element = element.parent().addClass('in').parent();
        } else {
            break;
        }
    }
});

function drawCalendarEvent(calendarEvent) {
    if(calendarEvent.production) {
        drawProductionModal(calendarEvent);
        $("#productionModal").modal();
    }
    else {
        drawDailyModal(calendarEvent);
        $("#dailyModal").modal();
    }
}

function drawProductionModal(calendarEvent) {
    $("#productionModal .modal-title").text('Sprint ' + calendarEvent.sprint + ' - ' + calendarEvent.project);
    $("#productionModal .modal-start span").text(calendarEvent.start.format('ddd, D MMM YYYY'));
}

function drawDailyModal(calendarEvent) {
    $("#dailyModal .modal-title").text('Sprint ' + calendarEvent.sprint + ' - ' + calendarEvent.project);

    $("#dailyModal .modal-user span").text(calendarEvent.user);
    $("#dailyModal .modal-comments span").text(calendarEvent.comments);

    if(calendarEvent.allDay) {
        $("#dailyModal .modal-start span").text(calendarEvent.start.format('ddd, D MMM YYYY'));
        $("#dailyModal .modal-end span").text('All day');                
    }
    else {
        $("#dailyModal .modal-start span").text(calendarEvent.start.format('ddd, D MMM YYYY, h:mm A'));
        $("#dailyModal .modal-end span").text(calendarEvent.end.format('ddd, D MMM YYYY, h:mm A'));                
    }
}

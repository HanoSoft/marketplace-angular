
/*navbar*/

/******************************

 [Table of Contents]

 1. Vars and Inits
 2. Set Header
 3. Init Menu
 4. Init Timer
 5. Init Favorite
 6. Init Fix Product Border
 7. Init Isotope Filtering
 8. Init Slider


 ******************************/

jQuery(document).ready(function($)
{
    "use strict";

    /*

    1. Vars and Inits

    */

    var header = $('.header');
    var topNav = $('.top_nav')
    var mainSlider = $('.main_slider');
    var hamburger = $('.hamburger_container');
    var menu = $('.hamburger_menu');
    var menuActive = false;
    var hamburgerClose = $('.hamburger_close');
    var fsOverlay = $('.fs_menu_overlay');

    setHeader();

    $(window).on('resize', function()
    {
        initFixProductBorder();
        setHeader();
    });

    $(document).on('scroll', function()
    {
        setHeader();
    });

    initMenu();
    initTimer();
    initFavorite();
    initFixProductBorder();
    initIsotopeFiltering();
    initSlider();

    /*

    2. Set Header

    */

    function setHeader()
    {
        if(window.innerWidth < 992)
        {
            if($(window).scrollTop() > 100)
            {
                header.css({'top':"0"});
            }
            else
            {
                header.css({'top':"0"});
            }
        }
        else
        {
            if($(window).scrollTop() > 100)
            {
                header.css({'top':"-50px"});
            }
            else
            {
                header.css({'top':"0"});
            }
        }
        if(window.innerWidth > 991 && menuActive)
        {
            closeMenu();
        }
    }

    /*

    3. Init Menu

    */

    function initMenu()
    {
        if(hamburger.length)
        {
            hamburger.on('click', function()
            {
                if(!menuActive)
                {
                    openMenu();
                }
            });
        }

        if(fsOverlay.length)
        {
            fsOverlay.on('click', function()
            {
                if(menuActive)
                {
                    closeMenu();
                }
            });
        }

        if(hamburgerClose.length)
        {
            hamburgerClose.on('click', function()
            {
                if(menuActive)
                {
                    closeMenu();
                }
            });
        }

        if($('.menu_item').length)
        {
            var items = document.getElementsByClassName('menu_item');
            var i;

            for(i = 0; i < items.length; i++)
            {
                if(items[i].classList.contains("has-children"))
                {
                    items[i].onclick = function()
                    {
                        this.classList.toggle("active");
                        var panel = this.children[1];
                        if(panel.style.maxHeight)
                        {
                            panel.style.maxHeight = null;
                        }
                        else
                        {
                            panel.style.maxHeight = panel.scrollHeight + "px";
                        }
                    }
                }
            }
        }
    }
    function openMenu()
    {
        menu.addClass('active');
        // menu.css('right', "0");
        fsOverlay.css('pointer-events', "auto");
        menuActive = true;
    }

    function closeMenu()
    {
        menu.removeClass('active');
        fsOverlay.css('pointer-events', "none");
        menuActive = false;
}});

/*--------------------------------product ----------------------------------------------------*/
function checkWindowSize() {
    if ( jQuery(window).width() >= 480 ) {
        $('.truncate').succinct({
            size: 100
        });
    }
    else if ( jQuery(window).width() >= 320 ) {
        $('.truncate').succinct({
            size: 55
        });
    }
    else {
        $('.truncate').succinct({
            size: 150
        });
    }
}

jQuery(document).ready(function(){
    jQuery(window).resize(checkWindowSize);
    checkWindowSize();
});
/*-------------------------------------------product-details-------------------------------------------------*/
$("#carousel-custom").carousel();

// Enable Carousel Indicators
$(".item").click(function(){
    $("#carousel-custom").carousel(1);
});

// Enable Carousel Controls
$(".left").click(function(){
    $("#carousel-custom").carousel("prev");
});



document.addEventListener('DOMContentLoaded', () => {
    const element = document.querySelector('.pausemenu');
    const tiltDeg = 2;
    element.addEventListener('mousemove', ({ clientX, clientY }) => {
        const bcr = element.getBoundingClientRect();
        const rotX = ((clientY - bcr.top) / bcr.height) * tiltDeg;
        const rotY = ((clientX - bcr.left) / bcr.width) * -tiltDeg;
        element.style.transform = `rotateX(${rotX}deg) rotateY(${rotY}deg)`;
    });

    element.addEventListener('mouseleave', () => {
        element.style.transform = `rotateX(0deg) rotateY(0deg)`;
    });

    window.addEventListener('message', function(event) {
        if (event.data.type === "pausemenu") {
            const pauseMenu = document.querySelector('.pausemenu');
            const root = document.querySelector('.root'); 
            const continuetext = document.querySelector('#continue-btn'); 
            continuetext.innerHTML = '<div class="button-icon"><i class="fa-solid fa-play"></i></div>'+event.data.locale.resume;
            const maptext = document.querySelector('#map-btn'); 
            maptext.innerHTML = '<div class="button-icon"><i class="fa-solid fa-street-view"></i></div>'+event.data.locale.map;
            const settingstext = document.querySelector('#settings-btn'); 
            settingstext.innerHTML = '<div class="button-icon"><i class="fa-solid fa-cog"></i></div>'+event.data.locale.settings;
            const logouttext = document.querySelector('#logout-btn'); 
            logouttext.innerHTML = '<div class="button-icon"><i class="fa-solid fa-arrow-right-from-bracket"></i></div>'+event.data.locale.quit;
            const name = document.querySelector('.charactername'); 
            name.innerHTML = event.data.name;
            root.style.display = "block";

        }
    });

        document.addEventListener("keydown", (event) => {
        if (event.key === "Escape") {
            if (menu) {
                fetch('https://ns-pausemenuv2/continue', {
                    method: 'POST',
                    body: JSON.stringify({})
                })
            } 
        }
    });

    window.addEventListener('message', function(event) {
        let data = event.data;
        if (data.type === "menu-pos") {
            // UI elementini ekrandaki doğru konuma taşıyoruz
            const pauseMenu = document.querySelector('.pausemenu');
            pauseMenu.style.left = `${event.data.x * window.innerWidth}px`;
            pauseMenu.style.top = `${event.data.y * window.innerHeight}px`;
        }
    });
    
    

    window.addEventListener('message', function(event) {
        if (event.data.type === "closemenu") {
            const root = document.querySelector('.root'); 
            root.style.display = "none";
        }
    });

    document.getElementById('continue-btn').addEventListener('click', () => {
        fetch('https://ns-pausemenuv2/continue', {
            method: 'POST',
            body: JSON.stringify({})
        })
    });

    document.getElementById('map-btn').addEventListener('click', () => {
        fetch('https://ns-pausemenuv2/map', {
            method: 'POST',
            body: JSON.stringify({})
        })
    });

    document.getElementById('settings-btn').addEventListener('click', () => {
        fetch('https://ns-pausemenuv2/settings', {
            method: 'POST',
            body: JSON.stringify({})
        })
    });

    document.getElementById('logout-btn').addEventListener('click', () => {
        fetch('https://ns-pausemenuv2/logout', {
            method: 'POST',
            body: JSON.stringify({})
        })
    });
});

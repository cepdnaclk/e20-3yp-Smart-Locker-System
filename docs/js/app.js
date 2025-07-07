// Smart Locker System - Vanilla JavaScript
// Author: Secure X Team
// Description: Main JavaScript file for the Smart Locker System website

// Global Variables
let currentModalImage = null;
let teamMembers = [];
let componentData = [];
let galleryItems = [];

// DOM Content Loaded Event
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

// Initialize the application
function initializeApp() {
    setupNavigation();
    setupHomeScrollEffect();
    // setupModalFunctionality(); // DISABLED: Modal functionality for testing images
    setupHoverEffects();
    loadTeamData();
    loadComponentData();
    loadGalleryData();
    renderTeamSection();
    renderBudgetTable();
    renderGallerySection();
    setupResponsiveMenu();
}

// Navigation functionality
function setupNavigation() {
    const navLinks = document.querySelectorAll('.navlist a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Active nav link highlighting
    window.addEventListener('scroll', highlightActiveNavLink);
}

// Highlight active navigation link based on scroll position
function highlightActiveNavLink() {
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.navlist a');
    
    let currentSection = '';
    
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        
        if (window.scrollY >= sectionTop - 100) {
            currentSection = section.getAttribute('id');
        }
    });
    
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href').substring(1) === currentSection) {
            link.classList.add('active');
        }
    });
}

// Home section scroll effect for background zoom
function setupHomeScrollEffect() {
    const homeBackground = document.querySelector('.home-bg');
    
    if (homeBackground) {
        window.addEventListener('scroll', function() {
            const scrollY = window.scrollY;
            const scale = Math.max(1 - scrollY * 0.0005, 0.85);
            homeBackground.style.transform = `scale(${scale})`;
        });
    }
}

// DISABLED: Modal functionality for image zoom
/*
function setupModalFunctionality() {
    // Setup modal for gallery images
    const galleryImages = document.querySelectorAll('.gallery-image');
    
    galleryImages.forEach(image => {
        image.addEventListener('click', function() {
            openImageModal(this.src, this.alt);
        });
    });
    
    // Setup modal for architecture images
    const architectureImages = document.querySelectorAll('.solarc-img');
    
    architectureImages.forEach(image => {
        image.addEventListener('click', function() {
            openImageModal(this.src, this.alt);
        });
    });
}

// Open image modal
function openImageModal(imageSrc, imageAlt) {
    const modal = document.createElement('div');
    modal.className = 'modal-overlay';
    modal.innerHTML = `
        <img src="${imageSrc}" alt="${imageAlt}" class="modal-image">
        <button class="modal-close-btn" aria-label="Close zoomed image">&times;</button>
    `;
    
    document.body.appendChild(modal);
    document.body.style.overflow = 'hidden';
    
    // Close modal events
    modal.addEventListener('click', closeImageModal);
    modal.querySelector('.modal-close-btn').addEventListener('click', closeImageModal);
    
    // ESC key to close modal
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeImageModal();
        }
    });
}

// Close image modal
function closeImageModal() {
    const modal = document.querySelector('.modal-overlay');
    if (modal) {
        modal.remove();
        document.body.style.overflow = 'auto';
    }
}
*/

// Setup hover effects for interactive elements
function setupHoverEffects() {
    // Team card hover effects
    const teamCards = document.querySelectorAll('.team-card');
    
    teamCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
    
    // Button hover effects
    const buttons = document.querySelectorAll('.buttonsec button');
    
    buttons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-3px) scale(1.02)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

// Load team data 

function loadTeamData() {/*
    teamMembers = [
        {
            id: 1,
            name: "Bandara K.G.R.I.",
            role: "E/20/036",
            image: "images/E20036.jpg",
            bio: "",
            portfolio: "https://www.thecn.com/EB1155",
            github: "https://github.com/induwara23630",
            linkedin: "https://linkedin.com/in/bill",
            email: "e20036@eng.pdn.ac.lk"
        },
        {
            id: 2,
            name: "Kumarasinghe R.M.S.H.",
            role: "E/20/212",
            image: "images/E20212.jpg",
            bio: "",
            portfolio: "https://www.thecn.com/RK950",
            github: "https://github.com/sameera-87",
            linkedin: "https://linkedin.com/in/iscool",
            email: "e20212@eng.pdn.ac.lk"
        },
        {
            id: 3,
            name: "Sandamali J.P.D.N.",
            role: "E/20/350",
            image: "images/E20350.jpg",
            bio: "",
            portfolio: "https://kochi.dev",
            github: "https://github.com/kochi",
            linkedin: "https://linkedin.com/in/kochi",
            email: "e20350@eng.pdn.ac.lk"
        },
        {
            id: 4,
            name: "Sidantha V.P.H.",
            role: "E/20/377",
            image: "images/E20377.jpg",
            bio: "",
            portfolio: "thecn.com/VS755",
            github: "https://github.com/sidantha0377",
            linkedin: "https://linkedin.com/in/magu",
            email: "e20377@eng.pdn.ac.lk"
        },
        {
            id: 5,
            name: "Dr. Isuru Nawinne",
            role: "Project Supervisor",
            image: "images/isuru-nawinne.png"
			
        }
    ];*/
}

// Load component data for budget
function loadComponentData() {
    componentData = [
        { component: "ESP32 Board", unitPrice: 1790, units: 2, price: 3580 },
        { component: "Ultrasonic Sensor", unitPrice: 1090, units: 3, price: 3270 },
        { component: "Solenoid Lock", unitPrice: 1950, units: 3, price: 5850 },
        { component: "Led(Red,Green)", unitPrice: 5, units: 6, price: 30 },
        { component: "Relay Module", unitPrice: 845, units: 3, price: 2535 },
        { component: "20x4 LCD Display", unitPrice: 990, units: 1, price: 990 },
        { component: "R305 Fingerprint Sensor", unitPrice: 9950, units: 1, price: 9950 },
        { component: "4x4 Keypad", unitPrice: 220, units: 1, price: 220 },
        { component: "I2C module(Keypad)", unitPrice: 900, units: 1, price: 900 },
        { component: "I2C module(LCD Display)", unitPrice: 250, units: 1, price: 250 },
        { component: "5V SMPC Power supply", unitPrice: 1390, units: 1, price: 1390 },
        { component: "12V SMPC Power supply", unitPrice: 3290, units: 1, price: 3290 }
    ];
}

// Load gallery data for testing section
function loadGalleryData() {
    galleryItems = [
        {
            id: 1,
            image: "images/fronttest.png",
            title: "Frontend Testing",
            description: "React testing library"
        },
        {
            id: 2,
            image: "images/back test.png",
            title: "Backend testing",
            description: "JUnit, Mokito - Unit testing"
        },
        {
            id: 3,
            image: "images/hadtest.png",
            title: "Backend testing",
            description: "Mqtt Explorer - Test mqtt messages"
        }
    ];
}

// Render team section

function renderTeamSection() {
	/*
    const teamGrid = document.querySelector('.team-grid');
    if (!teamGrid) return;
    
    teamGrid.innerHTML = '';
    
    teamMembers.forEach((member, index) => {
        const teamCard = document.createElement('div');
        teamCard.className = 'team-card';
        teamCard.style.animationDelay = `${(index + 1) * 0.1}s`;
        
        let socialLinks = '';
        if (member.portfolio) {
            socialLinks += `<a href="${member.portfolio}" target="_blank" rel="noopener noreferrer" class="social-link portfolio" title="Portfolio"><img src="images/globe.png" alt="Portfolio Icon" width="20" height="20" /></a>`;
        }
        if (member.github) {
            socialLinks += `<a href="${member.github}" target="_blank" rel="noopener noreferrer" class="social-link github" title="GitHub"><img src="images/github.svg" alt="Portfolio Icon" width="20" height="20" /></a>`;
        }
        if (member.linkedin) {
            socialLinks += `<a href="${member.linkedin}" target="_blank" rel="noopener noreferrer" class="social-link linkedin" title="LinkedIn"><img src="images/linkedin.svg" alt="Portfolio Icon" width="20" height="20" /></a>`;
        }
        if (member.email) {
            socialLinks += `<a href="mailto:${member.email}" class="social-link email" title="Email"><img src="images/mail.svg" alt="Portfolio Icon" width="20" height="20" /></a>`;
        }
        
        teamCard.innerHTML = `
            <div class="team-image-container">
                <img src="${member.image}" alt="${member.name}" class="team-image">
                <div class="team-image-overlay"></div>
            </div>
            <div class="team-content">
                <h3 class="team-name">${member.name}</h3>
                <p class="team-role">${member.role}</p>
                <p class="team-bio">${member.bio}</p>
                <div class="team-social-links">
                    ${socialLinks}
                </div>
            </div>
        `;
        
        teamGrid.appendChild(teamCard);
    });*/
}

// Render budget table
function renderBudgetTable() {
    const tableBody = document.querySelector('.table-body');
    if (!tableBody) return;
    
    tableBody.innerHTML = '';
    
    componentData.forEach((item, index) => {
        const row = document.createElement('tr');
        row.className = 'table-row';
        
        row.innerHTML = `
            <td class="table-cell component-name">${item.component}</td>
            <td class="table-cell unit-price">${item.unitPrice.toLocaleString()}</td>
            <td class="table-cell units">${item.units}</td>
            <td class="table-cell total-price">${item.price.toLocaleString()}</td>
        `;
        
        tableBody.appendChild(row);
    });
    
    // Update total
    const total = componentData.reduce((sum, item) => sum + item.price, 0);
    const totalCell = document.querySelector('.grand-total');
    if (totalCell) {
        totalCell.textContent = total.toLocaleString();
    }
    
    // Update summary stats
    const totalComponents = document.querySelector('.stat-item:first-child');
    const totalUnits = document.querySelector('.stat-item:last-child');
    
    if (totalComponents) {
        totalComponents.textContent = `Total Components: ${componentData.length}`;
    }
    
    if (totalUnits) {
        const unitSum = componentData.reduce((sum, item) => sum + item.units, 0);
        totalUnits.textContent = `Total Units: ${unitSum}`;
    }
}

// Render gallery section - MODIFIED: Removed click event for zoom
function renderGallerySection() {
    const galleryContainer = document.querySelector('.gallery-container');
    if (!galleryContainer) return;
    
    galleryContainer.innerHTML = '';
    
    galleryItems.forEach((item, index) => {
        const galleryItem = document.createElement('div');
        galleryItem.className = `gallery-item ${index % 2 === 1 ? 'reverse' : ''}`;
        
        galleryItem.innerHTML = `
            <div class="gallery-image-wrapper">
                <img src="${item.image}" alt="${item.title}" class="gallery-image">
            </div>
            <div class="gallery-text">
                <h2 class="gallery-title">${item.title}</h2>
                <p class="gallery-description">${item.description}</p>
            </div>
        `;
        
        // REMOVED: Click event for image zoom
        /*
        const imageWrapper = galleryItem.querySelector('.gallery-image-wrapper');
        imageWrapper.addEventListener('click', function() {
            openImageModal(item.image, item.title);
        });
        */
        
        galleryContainer.appendChild(galleryItem);
    });
}

// Setup responsive menu (for mobile)
function setupResponsiveMenu() {
    const navbar = document.querySelector('.navbar');
    const navList = document.querySelector('.navlist');
    
    // Create mobile menu toggle button
    const mobileMenuBtn = document.createElement('button');
    mobileMenuBtn.className = 'mobile-menu-btn';
    mobileMenuBtn.innerHTML = '☰';
    mobileMenuBtn.style.display = 'none';
    mobileMenuBtn.style.background = 'none';
    mobileMenuBtn.style.border = 'none';
    mobileMenuBtn.style.color = 'white';
    mobileMenuBtn.style.fontSize = '1.5rem';
    mobileMenuBtn.style.cursor = 'pointer';
    
    // Insert mobile menu button
    navbar.insertBefore(mobileMenuBtn, navList);
    
    // Toggle mobile menu
    mobileMenuBtn.addEventListener('click', function() {
        navList.classList.toggle('mobile-open');
    });
    
    // Close mobile menu when clicking on links
    const navLinks = document.querySelectorAll('.navlist a');
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            navList.classList.remove('mobile-open');
        });
    });
    
    // Handle window resize
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768) {
            navList.classList.remove('mobile-open');
            mobileMenuBtn.style.display = 'none';
        } else {
            mobileMenuBtn.style.display = 'block';
        }
    });
    
    // Initial check
    if (window.innerWidth <= 768) {
        mobileMenuBtn.style.display = 'block';
    }
}

// Utility function to format numbers
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Utility function to create elements
function createElement(tag, className, textContent) {
    const element = document.createElement(tag);
    if (className) element.className = className;
    if (textContent) element.textContent = textContent;
    return element;
}

// Smooth scroll animation
function smoothScrollTo(targetPosition, duration = 1000) {
    const startPosition = window.scrollY;
    const distance = targetPosition - startPosition;
    const startTime = performance.now();
    
    function animation(currentTime) {
        const timeElapsed = currentTime - startTime;
        const progress = Math.min(timeElapsed / duration, 1);
        const ease = easeInOutQuad(progress);
        
        window.scrollTo(0, startPosition + distance * ease);
        
        if (timeElapsed < duration) {
            requestAnimationFrame(animation);
        }
    }
    
    requestAnimationFrame(animation);
}

// Easing function for smooth scrolling
function easeInOutQuad(t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
}

// Initialize animations when elements come into view
function initializeScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    // Observe elements that should animate
    const elementsToObserve = document.querySelectorAll('.intro, .solarc, .hard, .test, .budget, .team, .link');
    elementsToObserve.forEach(el => observer.observe(el));
}

// Initialize scroll animations when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    initializeScrollAnimations();
});

// Export functions for potential use in other files - MODIFIED: Removed modal functions
window.SecureXApp = {
    initializeApp,
    setupNavigation,
    // openImageModal,  // REMOVED
    // closeImageModal, // REMOVED
    renderTeamSection,
    renderBudgetTable,
    renderGallerySection,
    formatNumber,
    smoothScrollTo
};
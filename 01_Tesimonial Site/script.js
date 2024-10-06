const helpButton = document.getElementById('helpButton');
const helpPopup = document.getElementById('helpPopup');

helpButton.addEventListener('click', () => {
    helpPopup.style.display = helpPopup.style.display === 'flex' ? 'none' : 'flex';
});

document.addEventListener('click', (e) => {
    if (!helpButton.contains(e.target) && !helpPopup.contains(e.target)) {
        helpPopup.style.display = 'none';
    }
});

const reviewPopup = document.getElementById('reviewPopup');
const reviews = [
    {
        name: "Alex Chen",
        role: "Product Manager",
        rating: 5,
        text: "TestiFlow has transformed how we collect and display testimonials. It's incredibly user-friendly!"
    },
    {
        name: "Emily Watson",
        role: "Marketing Specialist",
        rating: 4,
        text: "Great tool for managing customer feedback. The analytics feature is particularly helpful."
    },
    {
        name: "Carlos Rodriguez",
        role: "Small Business Owner",
        rating: 5,
        text: "I've seen a significant increase in conversions since adding TestiFlow testimonials to my site."
    },
    {
        name: "Sarah Kim",
        role: "E-commerce Director",
        rating: 5,
        text: "TestiFlow streamlined our review process. It's a game-changer for our online store!"
    },
    {
        name: "Michael Brown",
        role: "Startup Founder",
        rating: 4,
        text: "Easy to use and visually appealing. It's helped us build trust with potential customers."
    }
];

let currentReviewIndex = 0;
let popupVisible = false;

function showReviewPopup() {
    const review = reviews[currentReviewIndex];
    reviewPopup.innerHTML = `
        <span class="close-btn" onclick="closeReviewPopup()">&times;</span>
        <h4>Customer Review</h4>
        <div class="rating">
            ${Array(review.rating).fill('<i class="fas fa-star"></i>').join('')}
        </div>
        <p>"${review.text}"</p>
        <p><strong>- ${review.name}, ${review.role}</strong></p>
    `;
    
    if (!popupVisible) {
        reviewPopup.style.display = 'block';
        popupVisible = true;
    }

    currentReviewIndex = (currentReviewIndex + 1) % reviews.length;
}

function closeReviewPopup() {
    reviewPopup.style.display = 'none';
    popupVisible = false;
}

// Show a new review every 5 seconds
setInterval(showReviewPopup, 5000);

// Show the first review popup after 2 seconds
setTimeout(() => {
    showReviewPopup();
    // Start the rotation immediately after showing the first review
    setInterval(showReviewPopup, 5000);
}, 2000);

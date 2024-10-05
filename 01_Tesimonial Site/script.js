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

// Music Wrapped - Main JavaScript

// Interactive Terminal for Dashboard
document.addEventListener('DOMContentLoaded', function() {
    const commandMenu = document.getElementById('commandMenu');
    const terminalResult = document.getElementById('terminalResult');
    const resultOutput = document.getElementById('resultOutput');
    
    if (commandMenu) {
        const commandItems = commandMenu.querySelectorAll('.command-item');
        let selectedIndex = 0;
        
        // Initialize - select first command
        function updateSelection() {
            commandItems.forEach((item, index) => {
                if (index === selectedIndex) {
                    item.classList.add('selected');
                } else {
                    item.classList.remove('selected');
                }
            });
        }
        
        // Execute selected command
        function executeCommand() {
            const selectedCommand = commandItems[selectedIndex];
            const type = selectedCommand.dataset.type; // 'list' or undefined
            const result = selectedCommand.dataset.result;
            const label = selectedCommand.dataset.label;
            const extra = selectedCommand.dataset.extra;
            
            // Hide menu, show result section
            commandMenu.style.display = 'none';
            document.querySelector('.terminal-help').style.display = 'none';
            terminalResult.style.display = 'block';
            
            // Animate execution
            setTimeout(() => {
                let output = '';
                
                if (type === 'list') {
                    // Handle list results (top 5 artists/songs/albums)
                    output = `<div class="result-line success">
                        <span class="result-label">${label}:</span>
                    </div>`;
                    
                    // Get the appropriate data based on the index
                    let listData = [];
                    if (selectedIndex === 1) {
                        // Top artists - from template variable
                        listData = window.topArtistsData || [];
                    } else if (selectedIndex === 2) {
                        // Top songs
                        listData = window.topSongsData || [];
                    } else if (selectedIndex === 3) {
                        // Top albums
                        listData = window.topAlbumsData || [];
                    }
                    
                    if (listData.length > 0) {
                        output += '<div class="result-list">';
                        listData.forEach((item, i) => {
                            output += `<div class="result-list-item">
                                <span class="list-number">${i + 1}.</span>
                                <span class="list-name">${item.name}</span>
                                ${item.extra ? `<span class="list-extra">${item.extra}</span>` : ''}
                                <span class="list-count">${item.count} plays</span>
                            </div>`;
                        });
                        output += '</div>';
                    } else {
                        output += '<div class="result-line">No data available</div>';
                    }
                } else {
                    // Handle single value results
                    output = `<div class="result-line success">
                        <span class="result-label">RESULT:</span>
                        <span class="result-value">${result}</span>
                    </div>`;
                    
                    if (label) {
                        output += `<div class="result-line">
                            <span class="result-sublabel">${label}</span>
                        </div>`;
                    }
                    
                    if (extra) {
                        output += `<div class="result-line highlight">
                            <span class="result-extra">${extra}</span>
                        </div>`;
                    }
                }
                
                output += `<div class="result-action">
                    <span class="blink-text">PRESS ANY KEY TO RETURN...</span>
                </div>`;
                
                resultOutput.innerHTML = output;
                
                // Return to menu on any key
                const returnHandler = function(e) {
                    commandMenu.style.display = 'block';
                    document.querySelector('.terminal-help').style.display = 'block';
                    terminalResult.style.display = 'none';
                    resultOutput.innerHTML = '';
                    document.removeEventListener('keydown', returnHandler);
                };
                
                document.addEventListener('keydown', returnHandler);
            }, 1500);
        }
        
        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            // Only handle if menu is visible
            if (commandMenu.style.display === 'none') return;
            
            if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = (selectedIndex - 1 + commandItems.length) % commandItems.length;
                updateSelection();
            } else if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = (selectedIndex + 1) % commandItems.length;
                updateSelection();
            } else if (e.key === 'Enter') {
                e.preventDefault();
                executeCommand();
            }
        });
        
        // Mouse click on commands
        commandItems.forEach((item, index) => {
            item.addEventListener('click', function() {
                selectedIndex = index;
                updateSelection();
                executeCommand();
            });
            
            item.addEventListener('mouseenter', function() {
                selectedIndex = index;
                updateSelection();
            });
        });
        
        // Initialize selection
        updateSelection();
    }
    
    // Close alert messages (existing code)
    const closeButtons = document.querySelectorAll('.close-alert');
    
    closeButtons.forEach(button => {
        button.addEventListener('click', function() {
            this.parentElement.style.display = 'none';
        });
    });

    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.style.display = 'none';
            }, 300);
        }, 5000);
    });
});

// Confirm delete actions
function confirmDelete(itemName) {
    return confirm(`Are you sure you want to delete "${itemName}"? This action cannot be undone.`);
}

// Form validation
document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = 'var(--error-color)';
                } else {
                    field.style.borderColor = '#404040';
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('Please fill in all required fields.');
            }
        });
    });
});

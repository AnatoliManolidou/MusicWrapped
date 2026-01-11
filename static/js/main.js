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
            const status = selectedCommand.dataset.status || 'QUERY COMPLETE';
            
            // Update terminal title based on query type
            const terminalTitle = document.getElementById('terminalTitle');
            const executingMessage = document.getElementById('executingMessage');
            
            // Set title based on selected command
            const queryTitles = [
                'TOTAL PLAYS ANALYSIS',
                'TOP ARTISTS COMPILATION',
                'TOP SONGS IDENTIFICATION',
                'ALBUM RANKING ANALYSIS',
                'JAM SESSION MATCHING',
                'EMOTIONAL PROFILE SCAN',
                'GENRE DOMINANCE DETECTION',
                'YEARLY ACTIVITY MAPPING'
            ];
            
            if (terminalTitle) {
                terminalTitle.textContent = queryTitles[selectedIndex] || 'QUERY RESULTS';
            }
            
            // Update executing message
            if (executingMessage) {
                executingMessage.innerHTML = `PROCESSING ${queryTitles[selectedIndex]}<span class="dots"></span>`;
            }
            
            // Hide menu, show result section
            commandMenu.style.display = 'none';
            document.querySelector('.terminal-help').style.display = 'none';
            terminalResult.style.display = 'block';
            
            // Animate execution
            setTimeout(() => {
                // Hide executing message and loader
                if (executingMessage) {
                    executingMessage.style.display = 'none';
                }
                const loader = document.querySelector('.result-loader');
                if (loader) {
                    loader.style.display = 'none';
                }
                
                let output = '';
                
                // Status banner (universal)
                output += `<div class="status-banner">${status}.</div>`;
                output += `<div class="status-divider">════════════════════════════════</div>`;
                
                if (type === 'list') {
                    // Handle list results (top 5 artists/songs/albums)
                    let listData = [];
                    let totalCount = 0;
                    
                    if (selectedIndex === 1) {
                        listData = window.topArtistsData || [];
                        totalCount = listData.reduce((sum, item) => sum + item.count, 0);
                    } else if (selectedIndex === 2) {
                        listData = window.topSongsData || [];
                        totalCount = listData.reduce((sum, item) => sum + item.count, 0);
                    } else if (selectedIndex === 3) {
                        listData = window.topAlbumsData || [];
                        totalCount = listData.reduce((sum, item) => sum + item.count, 0);
                    }
                    
                    if (listData.length > 0) {
                        output += '<div class="result-list-enhanced">';
                        listData.forEach((item, i) => {
                            output += `<div class="list-item-box">
                                <div class="list-rank">RANK ${i + 1}</div>
                                <div class="list-item-main">
                                    <div class="list-item-name">${item.name}</div>
                                    ${item.extra ? `<div class="list-item-artist">${item.extra}</div>` : ''}
                                </div>
                                <div class="list-item-count">${item.count} ▶</div>
                            </div>`;
                        });
                        output += '</div>';
                        
                        // Calculate diversity based on number of unique items
                        let diversity = 'LOW';
                        if (listData.length >= 5) {
                            diversity = 'HIGH';
                        } else if (listData.length >= 3) {
                            diversity = 'MEDIUM';
                        }
                        
                        // Add summary badges
                        output += `<div class="result-badges">
                            <div class="badge">TOTAL PLAYS: ${totalCount}</div>
                            <div class="badge">DIVERSITY: ${diversity}</div>
                        </div>`;
                    } else {
                        output += '<div class="result-main">NO DATA AVAILABLE</div>';
                    }
                } else if (type === 'chart') {
                    // Handle monthly chart
                    const monthlyData = window.monthlyData || {};
                    const months = monthlyData.months || [];
                    const data = monthlyData.data || [];
                    const maxCount = Math.max(...data, 1);
                    const totalPlays = data.reduce((sum, val) => sum + val, 0);
                    const avgPlays = totalPlays > 0 ? (totalPlays / 12).toFixed(0) : 0;
                    
                    output += '<div class="monthly-chart-terminal">';
                    months.forEach((month, i) => {
                        const count = data[i] || 0;
                        const height = maxCount > 0 ? (count / maxCount * 100).toFixed(0) : 0;
                        const isTopMonth = (i + 1) === monthlyData.topMonth;
                        const displayHeight = count > 0 ? Math.max(height, 15) : 0;
                        output += `<div class="chart-bar-container ${isTopMonth ? 'top-month' : ''}">
                            <div class="chart-bar" style="height: ${displayHeight}%; ${count === 0 ? 'border: 1px dashed #555; background: transparent;' : ''}">
                                ${count > 0 ? `<span class="bar-value">${count}</span>` : ''}
                            </div>
                            <span class="bar-label">${month}</span>
                        </div>`;
                    });
                    output += '</div>';
                    
                    // Add chart badges
                    if (monthlyData.topMonth && monthlyData.topMonthCount > 0) {
                        const topMonthName = months[monthlyData.topMonth - 1];
                        const consistency = avgPlays > 0 ? Math.min(100, ((avgPlays / maxCount) * 100).toFixed(0)) : 0;
                        output += `<div class="result-badges">
                            <div class="badge">PEAK: ${topMonthName.toUpperCase()}</div>
                            <div class="badge">${monthlyData.topMonthCount} PLAYS</div>
                        </div>`;
                        output += `<div class="result-meter">
                            <div class="meter-label">CONSISTENCY SCORE:</div>
                            <div class="meter-bar">
                                <div class="meter-fill" style="width: ${consistency}%"></div>
                            </div>
                            <div class="meter-value">${consistency}%</div>
                        </div>`;
                    }
                } else {
                    // Handle single value results (mood, genre, jam, total plays)
                    output += `<div class="result-main">${result}</div>`;
                    
                    if (label) {
                        output += `<div class="result-subtitle">${label}</div>`;
                    }
                    
                    // Parse extra for badges (split by |)
                    if (extra) {
                        const parts = extra.split('|').map(s => s.trim());
                        
                        if (parts.length > 1 && selectedIndex === 4) {
                            // Jam sessions - special handling
                            output += `<div class="result-flavor">${parts[0]}</div>`;
                            if (parts.length > 1) {
                                output += `<div class="result-badges">`;
                                for (let i = 1; i < parts.length; i++) {
                                    output += `<div class="badge">${parts[i]}</div>`;
                                }
                                output += `</div>`;
                            }
                            // Add sync meter for jam
                            output += `<div class="result-meter">
                                <div class="meter-label">SYNC LEVEL:</div>
                                <div class="meter-bar">
                                    <div class="meter-fill" style="width: 96%"></div>
                                </div>
                                <div class="meter-value">96%</div>
                            </div>`;
                        } else {
                            // Mood/Genre - show flavor text
                            output += `<div class="result-flavor">${extra}</div>`;
                        }
                    }
                }
                
                output += `<div class="result-action">
                    <span class="blink-text">PRESS [ANY KEY] TO CONTINUE ANALYSIS...</span>
                </div>`;
                
                resultOutput.innerHTML = output;
                
                // Return to menu on any key
                const returnHandler = function(e) {
                    // Reset title
                    const terminalTitle = document.getElementById('terminalTitle');
                    if (terminalTitle) {
                        terminalTitle.textContent = 'AVAILABLE QUERIES:';
                    }
                    
                    // Show executing message and loader again for next query
                    const executingMessage = document.getElementById('executingMessage');
                    if (executingMessage) {
                        executingMessage.style.display = 'block';
                    }
                    const loader = document.querySelector('.result-loader');
                    if (loader) {
                        loader.style.display = 'block';
                    }
                    
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

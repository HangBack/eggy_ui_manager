
class UINodesMerger {
    constructor() {
        this.data = {};
        this.stats = {
            totalElements: 0,
            duplicatedElements: 0,
            uniqueNames: 0,
            mergedGroups: 0
        };
        this.init();
    }

    init() {
        this.bindEvents();
    }

    bindEvents() {
        const fileInput = document.getElementById('fileInput');
        const fileInputArea = document.getElementById('fileInputArea');
        const processBtn = document.getElementById('processBtn');
        const clearBtn = document.getElementById('clearBtn');
        const copyBtn = document.getElementById('copyBtn');
        const downloadBtn = document.getElementById('downloadBtn');
        const tabs = document.querySelectorAll('.tab');

        // 文件拖拽
        fileInputArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            fileInputArea.classList.add('dragover');
        });

        fileInputArea.addEventListener('dragleave', () => {
            fileInputArea.classList.remove('dragover');
        });

        fileInputArea.addEventListener('drop', (e) => {
            e.preventDefault();
            fileInputArea.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                this.handleFile(files[0]);
            }
        });

        // 文件选择
        fileInput.addEventListener('change', () => {
            if (fileInput.files.length > 0) {
                this.handleFile(fileInput.files[0]);
            }
        });

        // 按钮事件
        processBtn.addEventListener('click', () => this.processData());
        clearBtn.addEventListener('click', () => this.clearAll());
        copyBtn.addEventListener('click', () => this.copyToClipboard());
        downloadBtn.addEventListener('click', () => this.downloadFile());

        // 标签切换
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                const targetTab = tab.dataset.tab;
                this.switchTab(targetTab);
            });
        });
    }

    handleFile(file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            document.getElementById('inputText').value = e.target.result;
            this.showMessage('文件加载成功！', 'success');
        };
        reader.onerror = () => {
            this.showMessage('文件读取失败，请重试。', 'error');
        };
        reader.readAsText(file, 'utf-8');
    }

    processData() {
        const inputText = document.getElementById('inputText').value.trim();
        if (!inputText) {
            this.showMessage('请先输入或选择文件内容。', 'error');
            return;
        }

        try {
            this.parseInput(inputText);
            this.generateOutput();
            this.updateStats();
            this.showPreview();
            this.showResultContainer();
            this.showMessage('数据处理完成！', 'success');
        } catch (error) {
            this.showMessage('处理数据时出错：' + error.message, 'error');
        }
    }

    parseInput(inputText) {
        this.data = {};
        const lines = inputText.split('\n');

        for (let line of lines) {
            line = line.trim();
            
            // 解析有效行 (包括注释的行)
            const match = line.match(/^\s*(?:--\s*)?\["([^"]+)"\]\s*=\s*"([^"]+)"\s*--\[\[@as\s+(\w+)\]\]/);
            if (match) {
                const [, name, id, type] = match;
                
                // 以ID为键，名称和类型为值
                this.data[id] = { name, type };
            }
        }
    }

    generateOutput() {
        let output = '---AUTTO EXPORT BY EGGITOR PLUGIN, PLEASE DO NOT EDIT\n\nreturn {\n';
        
        // 按ID排序
        const sortedIds = Object.keys(this.data).sort();
        
        for (let i = 0; i < sortedIds.length; i++) {
            const id = sortedIds[i];
            const item = this.data[id];
            
            // 格式: ["ID"] = {"名称", "类型"}
            output += `\t["${id}"] = {"${item.name}", "${item.type}"},\n`;
        }
        
        output += '}';
        document.getElementById('outputText').value = output;
    }

    updateStats() {
        let totalElements = 0;
        let duplicatedElements = 0;
        let mergedGroups = 0;

        for (const name in this.data) {
            const items = this.data[name];
            totalElements += items.length;
            if (items.length > 1) {
                duplicatedElements += items.length;
                mergedGroups++;
            }
        }

        this.stats = {
            totalElements,
            duplicatedElements,
            uniqueNames: Object.keys(this.data).length,
            mergedGroups
        };

        document.getElementById('totalElements').textContent = totalElements;
        document.getElementById('duplicatedElements').textContent = duplicatedElements;
        document.getElementById('uniqueNames').textContent = this.stats.uniqueNames;
        document.getElementById('mergedGroups').textContent = mergedGroups;
    }

    showPreview() {
        const previewSection = document.getElementById('previewSection');
        previewSection.innerHTML = '';

        const mergedGroups = Object.entries(this.data).filter(([name, items]) => items.length > 1);
        
        if (mergedGroups.length === 0) {
            previewSection.innerHTML = '<div class="preview-item"><div class="preview-name">没有发现重复的元素</div></div>';
            return;
        }

        mergedGroups.forEach(([name, items]) => {
            const previewItem = document.createElement('div');
            previewItem.className = 'preview-item';
            
            const itemsHtml = items.map(item => `"${item.id}" --[[@as ${item.type}]]`).join(',\n        ');
            
            previewItem.innerHTML = `
                <div class="preview-name">"${name}" (${items.length} 个元素)</div>
                <div class="preview-items">{
${itemsHtml}
}</div>
            `;
            
            previewSection.appendChild(previewItem);
        });
    }

    showResultContainer() {
        document.getElementById('statsContainer').style.display = 'grid';
        document.getElementById('resultContainer').style.display = 'block';
    }

    switchTab(targetTab) {
        document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        
        document.querySelector(`[data-tab="${targetTab}"]`).classList.add('active');
        document.getElementById(targetTab).classList.add('active');
    }

    copyToClipboard() {
        const outputText = document.getElementById('outputText');
        outputText.select();
        document.execCommand('copy');
        this.showMessage('已复制到剪贴板！', 'success');
    }

    downloadFile() {
        const content = document.getElementById('outputText').value;
        const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
        const url = URL.createObjectURL(blob);
        
        const a = document.createElement('a');
        a.href = url;
        a.download = 'UINodes_merged.lua';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        this.showMessage('文件下载已开始！', 'success');
    }

    clearAll() {
        document.getElementById('inputText').value = '';
        document.getElementById('outputText').value = '';
        document.getElementById('statsContainer').style.display = 'none';
        document.getElementById('resultContainer').style.display = 'none';
        document.getElementById('previewSection').innerHTML = '';
        document.getElementById('fileInput').value = '';
        this.data = {};
        this.stats = {};
        this.showMessage('已清空所有内容！', 'success');
    }

    showMessage(message, type) {
        // 移除现有消息
        document.querySelectorAll('.error-message, .success-message').forEach(el => el.remove());
        
        const messageDiv = document.createElement('div');
        messageDiv.className = type === 'error' ? 'error-message' : 'success-message';
        messageDiv.textContent = message;
        
        const mainContent = document.querySelector('.main-content');
        mainContent.insertBefore(messageDiv, mainContent.firstChild);
        
        // 3秒后自动移除
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.remove();
            }
        }, 3000);
    }
}

// 初始化应用
document.addEventListener('DOMContentLoaded', () => {
    new UINodesMerger();
});
// h1要素を取得
const title = document.getElementById('title');

// クリックイベントを追加
title.addEventListener('click', function() {
    title.textContent = 'Clicked!';
});

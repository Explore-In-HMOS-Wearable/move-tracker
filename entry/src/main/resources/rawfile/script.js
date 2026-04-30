function computeBounds(points) {
    let minLat= 90, maxLat= -90, minLon= 180, maxLon= -180;
    points.forEach(p => {
        if(p.lat < minLat) minLat = p.lat;
        if(p.lat > maxLat) maxLat = p.lat;
        if(p.lon < minLon) minLon = p.lon;
        if(p.lon > maxLon) maxLon = p.lon;
    });
    if(minLat === maxLat){
        minLat -= 0.0001;
        maxLat += 0.0001;
    }
    if(minLon === maxLon) {
        minLon -= 0.0001;
        maxLon += 0.0001;
    }
    return { minLat, maxLat, minLon, maxLon};
}

function latLonToXY(lat,lon,bounds,width,height) {
    const {minLat, maxLat, minLon, maxLon} = bounds;
    const x = ((lon-minLon) / (maxLon-minLon)) * width;
    const y = height - ((lat - minLat) / (maxLat - minLat)) * height;
    return {x,y};
}

function buildPolyline(points, width, height) {
    const bounds = computeBounds(points);
    const path = points.map(p => {
        const {x,y} = latLonToXY(p.lat, p.lon, bounds, width, height);
        return `${x.toFixed(1)},${y.toFixed(1)}`;
    }).join(' ');
    return { bounds, path };
}

function updateRuns(records) {
    const host = document.getElementById('runs');
    host.innerHTML = '';
    if(!records || records.length === 0){
        host.innerHTML = '<p class="info">No activities yet.</p>';
        return;
    }
    records.forEach((r, idx) => {
        const distKm = (r.distance / 1000).toFixed(2);
        const avgKmh = (r.avgSpeed * 3.6).toFixed(1);
        const mins = r.endTime ? ((r.endTime - r.startTime) / 60000).toFixed(1) : '...';
        const pts = r.points || [];
        const card = document.createElement('div');
        card.className = 'card';
        const header = document.createElement('div');
        header.className = 'row';
        const title = document.createElement('div');
        title.innerHTML = `<strong>Activity #${records.length - idx}</strong>`;
        const tags = document.createElement('div');
        tags.innerHTML = `<span class="pill">${distKm} km</span>`;
        header.appendChild(title);
        header.appendChild(tags);
        card.appendChild(header);
        const metrics = document.createElement('div');
        metrics.innerHTML = `
           <div class="metric"> Avg Speed: ${avgKmh} km/h</div>
           <div class="metric"> Duration: ${mins}</div>
           <div class="metric"> Points: ${pts.length}</div>
           `;
        card.appendChild(metrics);
        const svgWrap = document.createElement('div');
        svgWrap.className = 'svgwrap';
        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('viewBox', '0 0 400 200');
        svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
        if(pts.length > 0){
            const {path} = buildPolyline(pts, 400, 200);
            const polyLine = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
            polyLine.setAttribute('points', path);
            polyLine.setAttribute('fill', 'none');
            polyLine.setAttribute('stroke', '#4f46e5');
            polyLine.setAttribute('stroke-width', '3');
            polyLine.setAttribute('stroke-linecap', 'round');
            polyLine.setAttribute('stroke-linejoin', 'round');
            svg.appendChild(polyLine);
            const start =
                document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            start.setAttribute('r', '4');
            start.setAttribute('fill', '#10b981');
            const end = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            end.setAttribute('r', '4');
            end.setAttribute('fill', '#ef4444');
            const bounds = computeBounds(pts);
            const sXY = latLonToXY(pts[0].lat, pts[0].lon, bounds, 400, 200);
            const eXY = latLonToXY(pts[pts.length-1].lat, pts[pts.length-1].lon, bounds, 400, 200);
            start.setAttribute('cx', sXY.x.toFixed(1));
            start.setAttribute('cy', sXY.y.toFixed(1));
            end.setAttribute('cx', eXY.x.toFixed(1));
            end.setAttribute('cy', eXY.y.toFixed(1));
            svg.appendChild(start);
            svg.appendChild(end);

        }
        else{
            const t = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            t.textContent = 'No GPS points yet';
            t.setAttribute('x', '12');
            t.setAttribute('y', '24');
            t.setAttribute('font-size', '24');
            svg.appendChild(t);
        }
        svgWrap.appendChild(svg);
        card.appendChild(svgWrap);

        let pressTimer;
        card.addEventListener('touchstart', (e) => {
            pressTimer = setTimeout(() => {
                if (window.jsBridge && window.jsBridge.deleteActivity) {
                    window.jsBridge.deleteActivity(r.id);
                }
            }, 1000);
        });
        card.addEventListener('touchend', (e) => {
            clearTimeout(pressTimer);
        });
        card.addEventListener('touchmove', (e) => {
            clearTimeout(pressTimer);
        });

        host.appendChild(card);
    })
}
window.updateRuns = updateRuns;
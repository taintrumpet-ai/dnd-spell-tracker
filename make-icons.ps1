Add-Type -AssemblyName System.Drawing

function Make-Icon {
    param([int]$size, [string]$path)

    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g   = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode        = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.CompositingQuality   = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode    = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    $cx = [int]($size / 2)
    $cy = [int]($size / 2)

    # ── 1. Background: deep stone black ──────────────────
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 13, 10, 8))
    $g.FillRectangle($bgBrush, 0, 0, $size, $size)
    $bgBrush.Dispose()

    # Subtle stone horizontal grain
    $rng = New-Object System.Random(7)
    for ($i = 0; $i -lt 18; $i++) {
        $ly = $rng.Next(0, $size)
        $lw = $rng.Next([int]($size*0.4), $size)
        $lx = $rng.Next(0, $size - $lw)
        $la = $rng.Next(4, 12)
        $stBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($la, 70, 58, 46))
        $g.FillRectangle($stBrush, $lx, $ly, $lw, [int]($size * 0.004 + 1))
        $stBrush.Dispose()
    }

    # ── 2. Ambient torchlight glow (amber, behind helmet) ─
    $glowSteps = 20
    for ($i = $glowSteps; $i -gt 0; $i--) {
        $gr = [int]($size * 0.46 * [double]$i / [double]$glowSteps)
        $ga = [int](55.0 * (1.0 - [double]$i / [double]$glowSteps))
        if ($ga -lt 1) { $ga = 1 }
        $gBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($ga, 195, 118, 28))
        $g.FillEllipse($gBrush, ($cx - $gr), ($cy - $gr), ($gr * 2), ($gr * 2))
        $gBrush.Dispose()
    }

    # ── 3. Red cape ───────────────────────────────────────
    $cW   = [int]($size * 0.70)
    $cTop = [int]($cy - [int]($size * 0.06))
    $cBot = [int]($size * 0.97)
    $cHalf = [int]($cW / 2)

    # Main cape body
    $capePts = New-Object 'System.Drawing.PointF[]' 8
    $capePts[0] = [System.Drawing.PointF]::new([float]($cx - [int]($cW*0.13)), [float]$cTop)
    $capePts[1] = [System.Drawing.PointF]::new([float]($cx + [int]($cW*0.13)), [float]$cTop)
    $capePts[2] = [System.Drawing.PointF]::new([float]($cx + $cHalf),          [float]($cTop + [int]($size*0.11)))
    $capePts[3] = [System.Drawing.PointF]::new([float]($cx + $cHalf),          [float]$cBot)
    $capePts[4] = [System.Drawing.PointF]::new([float]($cx + [int]($cW*0.08)), [float]($cBot - [int]($size*0.05)))
    $capePts[5] = [System.Drawing.PointF]::new([float]$cx,                     [float]$cBot)
    $capePts[6] = [System.Drawing.PointF]::new([float]($cx - [int]($cW*0.08)), [float]($cBot - [int]($size*0.05)))
    $capePts[7] = [System.Drawing.PointF]::new([float]($cx - $cHalf),          [float]$cBot)
    $capeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 105, 14, 14))
    $g.FillPolygon($capeBrush, $capePts)
    $capeBrush.Dispose()

    # Left panel highlight
    $cHL = New-Object 'System.Drawing.PointF[]' 4
    $cHL[0] = [System.Drawing.PointF]::new([float]($cx - [int]($cW*0.13)), [float]$cTop)
    $cHL[1] = [System.Drawing.PointF]::new([float]($cx + [int]($cW*0.00)), [float]$cTop)
    $cHL[2] = [System.Drawing.PointF]::new([float]($cx - [int]($cW*0.06)), [float]$cBot)
    $cHL[3] = [System.Drawing.PointF]::new([float]($cx - $cHalf),          [float]$cBot)
    $cHLBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 150, 22, 22))
    $g.FillPolygon($cHLBrush, $cHL)
    $cHLBrush.Dispose()

    # Right shadow
    $cSR = New-Object 'System.Drawing.PointF[]' 4
    $cSR[0] = [System.Drawing.PointF]::new([float]($cx + [int]($cW*0.30)), [float]($cTop + [int]($size*0.11)))
    $cSR[1] = [System.Drawing.PointF]::new([float]($cx + $cHalf),          [float]($cTop + [int]($size*0.11)))
    $cSR[2] = [System.Drawing.PointF]::new([float]($cx + $cHalf),          [float]$cBot)
    $cSR[3] = [System.Drawing.PointF]::new([float]($cx + [int]($cW*0.24)), [float]$cBot)
    $cSRBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 72, 8, 8))
    $g.FillPolygon($cSRBrush, $cSR)
    $cSRBrush.Dispose()

    # ── 4. Knight helmet ──────────────────────────────────
    $hW     = [int]($size * 0.435)
    $hH     = [int]($size * 0.530)
    $hLeft  = $cx - [int]($hW / 2)
    $hTop   = [int]($cy - [int]($hH * 0.62))
    $domeH  = [int]($hH * 0.48)
    $bodyT  = [int]($hTop + [int]($domeH * 0.44))
    $bodyH  = [int]($hH * 0.62)

    $steelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 54, 58, 67))
    # Dome
    $g.FillEllipse($steelBrush, $hLeft, $hTop, $hW, $domeH)
    # Face/body
    $g.FillRectangle($steelBrush, $hLeft, $bodyT, $hW, $bodyH)
    $steelBrush.Dispose()

    # Left-side specular highlight on dome
    $specBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(48, 210, 225, 240))
    $g.FillEllipse($specBrush, ($hLeft + [int]($hW*0.11)), ($hTop + [int]($hH*0.04)), [int]($hW*0.24), [int]($domeH*0.72))
    $specBrush.Dispose()

    # Slight warm ambient on right side
    $warmBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(18, 195, 118, 28))
    $g.FillEllipse($warmBrush, ($hLeft + [int]($hW*0.65)), ($hTop + [int]($hH*0.06)), [int]($hW*0.28), [int]($domeH*0.60))
    $warmBrush.Dispose()

    # ── 5. Visor slot ─────────────────────────────────────
    $vY   = [int]($hTop + [int]($hH * 0.345))
    $vH   = [int]($size * 0.068)
    $vPad = [int]($hW * 0.065)
    $vW   = $hW - $vPad * 2

    $visorBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 5, 4, 3))
    $g.FillRectangle($visorBrush, ($hLeft + $vPad), $vY, $vW, $vH)
    $visorBrush.Dispose()

    # Amber eye-glow inside visor
    $eyeW = [int]($vW * 0.33)
    $eyeH = [int]($vH * 0.55)
    $eyeY = [int]($vY + [int]($vH * 0.22))
    $eyeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(55, 220, 140, 20))
    $g.FillEllipse($eyeBrush, ($hLeft + $vPad + [int]($vW*0.05)), $eyeY, $eyeW, $eyeH)
    $g.FillEllipse($eyeBrush, ($hLeft + $vPad + [int]($vW*0.62)), $eyeY, $eyeW, $eyeH)
    $eyeBrush.Dispose()

    # ── 6. Chin bars ──────────────────────────────────────
    $cbPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 26, 28, 34), [int]($size*0.016 + 1))
    $cbPad = [int]($hW * 0.09)
    $cbY0  = [int]($vY + $vH + [int]($size * 0.030))
    $cbSp  = [int]($size * 0.040)
    for ($i = 0; $i -lt 3; $i++) {
        $ly = $cbY0 + $i * $cbSp
        if ($ly -lt ($bodyT + $bodyH - [int]($size*0.02))) {
            $g.DrawLine($cbPen, ($hLeft + $cbPad), $ly, ($hLeft + $hW - $cbPad), $ly)
        }
    }
    $cbPen.Dispose()

    # ── 7. Pauldrons (shoulder plate) ─────────────────────
    $pdW = [int]($hW * 1.22)
    $pdH = [int]($size * 0.095)
    $pdY = [int]($bodyT + $bodyH - [int]($pdH * 0.28))
    $pdBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 46, 49, 57))
    $g.FillEllipse($pdBrush, ($cx - [int]($pdW/2)), $pdY, $pdW, $pdH)
    $pdBrush.Dispose()

    # ── 8. Gold trim on helmet ────────────────────────────
    $gt = [int]($size * 0.013 + 1)
    $goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 198, 162, 58), $gt)

    # Dome outline
    $g.DrawEllipse($goldPen, $hLeft, $hTop, $hW, $domeH)

    # Visor edges
    $vpThick = [int]($size * 0.008 + 1)
    $vpPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(170, 180, 145, 48), $vpThick)
    $g.DrawLine($vpPen, ($hLeft + $vPad), $vY,         ($hLeft + $hW - $vPad), $vY)
    $g.DrawLine($vpPen, ($hLeft + $vPad), ($vY + $vH), ($hLeft + $hW - $vPad), ($vY + $vH))

    # Centre ridge
    $ridgePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 198, 162, 58), [int]($size*0.011+1))
    $g.DrawLine($ridgePen, $cx, $hTop, $cx, $vY)

    # Pauldron outline
    $g.DrawEllipse($goldPen, ($cx - [int]($pdW/2)), $pdY, $pdW, $pdH)

    $goldPen.Dispose()
    $vpPen.Dispose()
    $ridgePen.Dispose()

    # ── 9. Outer gold border ──────────────────────────────
    $bR  = [int]($size * 0.464)
    $bT  = [int]($size * 0.022)
    if ($bT -lt 2) { $bT = 2 }
    $bPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(245, 198, 162, 58), $bT)
    $g.DrawEllipse($bPen, ($cx - $bR), ($cy - $bR), ($bR * 2), ($bR * 2))
    $bPen.Dispose()

    # Thin inner ring
    $iR  = [int]($size * 0.44)
    $iPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(90, 198, 162, 58), [int]($size*0.007+1))
    $g.DrawEllipse($iPen, ($cx - $iR), ($cy - $iR), ($iR * 2), ($iR * 2))
    $iPen.Dispose()

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Saved: $path ($size x $size)"
}

Make-Icon -size 512 -path 'C:\Users\tomhu\OneDrive\Documents\Claude\small scale project\icon-512.png'
Make-Icon -size 192 -path 'C:\Users\tomhu\OneDrive\Documents\Claude\small scale project\icon-192.png'
Make-Icon -size 180 -path 'C:\Users\tomhu\OneDrive\Documents\Claude\small scale project\icon-180.png'
Write-Host 'All icons generated!'

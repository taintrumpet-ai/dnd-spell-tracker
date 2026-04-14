Add-Type -AssemblyName System.Drawing

function Make-Icon {
    param([int]$size, [string]$path)

    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g   = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    $cx = [int]($size / 2)
    $cy = [int]($size / 2)

    # ── 1. Background: deep dark with faint warm centre ───
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 11, 9, 7))
    $g.FillRectangle($bgBrush, 0, 0, $size, $size)
    $bgBrush.Dispose()

    $glowSteps = 14
    for ($i = $glowSteps; $i -gt 0; $i--) {
        $gr = [int]($size * 0.44 * [double]$i / [double]$glowSteps)
        $ga = [int](28.0 * (1.0 - [double]$i / [double]$glowSteps))
        if ($ga -lt 1) { $ga = 1 }
        $gBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($ga, 160, 100, 28))
        $g.FillEllipse($gBrush, ($cx - $gr), ($cy - $gr), ($gr * 2), ($gr * 2))
        $gBrush.Dispose()
    }

    # ── 2. Helmet geometry ────────────────────────────────
    # Helmet sits slightly below the vertical centre so the plume has room above
    $hCY    = [int]($cy + [int]($size * 0.10))
    $hW     = [int]($size * 0.52)
    $hH     = [int]($size * 0.56)
    $hLeft  = $cx - [int]($hW / 2)
    $hTop   = [int]($hCY - [int]($hH * 0.52))
    $domeH  = [int]($hH * 0.44)
    $bodyT  = [int]($hTop + [int]($domeH * 0.38))
    $bodyH  = [int]($hH * 0.68)
    $crownY = [int]($hTop + [int]($domeH * 0.18))  # point where plume attaches

    # ── 3. Red plume (drawn BEFORE helmet so helmet sits on top) ──
    $pBase  = [int]($crownY + [int]($size * 0.03))
    $pTop   = [int]($size * 0.03)
    $pHalf  = [int]($size * 0.155)
    $pTaper = [int]($size * 0.022)

    # Layer A – darkest/widest (shadow)
    $pA = New-Object 'System.Drawing.PointF[]' 9
    $pA[0] = [System.Drawing.PointF]::new([float]($cx - $pHalf),             [float]$pBase)
    $pA[1] = [System.Drawing.PointF]::new([float]($cx + $pHalf),             [float]$pBase)
    $pA[2] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*1.18)), [float]([int]($pBase*0.72 + $pTop*0.28)))
    $pA[3] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.95)), [float]([int]($pBase*0.45 + $pTop*0.55)))
    $pA[4] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.55)), [float]([int]($pBase*0.18 + $pTop*0.82)))
    $pA[5] = [System.Drawing.PointF]::new([float]($cx + $pTaper),            [float]$pTop)
    $pA[6] = [System.Drawing.PointF]::new([float]($cx - $pTaper),            [float]$pTop)
    $pA[7] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.70)), [float]([int]($pBase*0.22 + $pTop*0.78)))
    $pA[8] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*1.10)), [float]([int]($pBase*0.68 + $pTop*0.32)))
    $brushA = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 88, 12, 12))
    $g.FillPolygon($brushA, $pA)
    $brushA.Dispose()

    # Layer B – mid red
    $pB = New-Object 'System.Drawing.PointF[]' 9
    $pB[0] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.76)), [float]$pBase)
    $pB[1] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.76)), [float]$pBase)
    $pB[2] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.90)), [float]([int]($pBase*0.70 + $pTop*0.30)))
    $pB[3] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.72)), [float]([int]($pBase*0.44 + $pTop*0.56)))
    $pB[4] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.38)), [float]([int]($pBase*0.16 + $pTop*0.84)))
    $pB[5] = [System.Drawing.PointF]::new([float]($cx + [int]($pTaper*0.6)), [float]([int]($pTop + [int]($size*0.018))))
    $pB[6] = [System.Drawing.PointF]::new([float]($cx - [int]($pTaper*0.6)), [float]([int]($pTop + [int]($size*0.018))))
    $pB[7] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.52)), [float]([int]($pBase*0.20 + $pTop*0.80)))
    $pB[8] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.80)), [float]([int]($pBase*0.66 + $pTop*0.34)))
    $brushB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 165, 24, 24))
    $g.FillPolygon($brushB, $pB)
    $brushB.Dispose()

    # Layer C – bright highlight (slightly left)
    $pC = New-Object 'System.Drawing.PointF[]' 7
    $pC[0] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.30)), [float]$pBase)
    $pC[1] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.30)), [float]$pBase)
    $pC[2] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.34)), [float]([int]($pBase*0.62 + $pTop*0.38)))
    $pC[3] = [System.Drawing.PointF]::new([float]($cx + [int]($pHalf*0.14)), [float]([int]($pBase*0.26 + $pTop*0.74)))
    $pC[4] = [System.Drawing.PointF]::new([float]$cx,                        [float]([int]($pTop + [int]($size*0.04))))
    $pC[5] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.18)), [float]([int]($pBase*0.28 + $pTop*0.72)))
    $pC[6] = [System.Drawing.PointF]::new([float]($cx - [int]($pHalf*0.28)), [float]([int]($pBase*0.58 + $pTop*0.42)))
    $brushC = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 210, 38, 38))
    $g.FillPolygon($brushC, $pC)
    $brushC.Dispose()

    # ── 4. Helmet dome ────────────────────────────────────
    $steelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 60, 70))
    $g.FillEllipse($steelBrush, $hLeft, $hTop, $hW, $domeH)

    # ── 5. Helmet face/body ───────────────────────────────
    $g.FillRectangle($steelBrush, $hLeft, $bodyT, $hW, $bodyH)
    $steelBrush.Dispose()

    # Dome specular highlight
    $specBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(52, 215, 228, 242))
    $g.FillEllipse($specBrush, ($hLeft + [int]($hW*0.10)), ($hTop + [int]($hH*0.04)), [int]($hW*0.26), [int]($domeH*0.70))
    $specBrush.Dispose()

    # Face side shading
    $shadeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 0, 0, 0))
    $g.FillRectangle($shadeBrush, ($hLeft + [int]($hW*0.72)), $bodyT, [int]($hW*0.28), $bodyH)
    $shadeBrush.Dispose()

    # ── 6. Visor (T-shape) ────────────────────────────────
    $vY   = [int]($hTop + [int]($hH * 0.33))
    $vH   = [int]($size * 0.072)
    $vPad = [int]($hW * 0.07)

    # Horizontal visor slot
    $visorBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 6, 5, 4))
    $g.FillRectangle($visorBrush, ($hLeft + $vPad), $vY, ($hW - $vPad*2), $vH)

    # Narrow vertical nose slot (T)
    $noseW = [int]($hW * 0.10)
    $noseH = [int]($size * 0.09)
    $g.FillRectangle($visorBrush, ($cx - [int]($noseW/2)), ($vY + $vH), $noseW, $noseH)
    $visorBrush.Dispose()

    # Amber eye glow inside visor
    $eyeW = [int](($hW - $vPad*2) * 0.36)
    $eyeH = [int]($vH * 0.50)
    $eyeY = [int]($vY + [int]($vH * 0.25))
    $eyeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 215, 135, 22))
    $g.FillEllipse($eyeBrush, ($hLeft + $vPad + [int](($hW - $vPad*2)*0.05)), $eyeY, $eyeW, $eyeH)
    $g.FillEllipse($eyeBrush, ($hLeft + $vPad + [int](($hW - $vPad*2)*0.59)), $eyeY, $eyeW, $eyeH)
    $eyeBrush.Dispose()

    # ── 7. Chin bars ─────────────────────────────────────
    $cbPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 24, 26, 32), [int]($size*0.018+1))
    $cbPad = [int]($hW * 0.09)
    $cbY0  = [int]($vY + $vH + [int]($hW * 0.09) + [int]($size*0.012))
    $cbSp  = [int]($size * 0.042)
    for ($i = 0; $i -lt 3; $i++) {
        $ly = $cbY0 + $i * $cbSp
        $maxY = $bodyT + $bodyH - [int]($size*0.025)
        if ($ly -lt $maxY) {
            $g.DrawLine($cbPen, ($hLeft + $cbPad), $ly, ($hLeft + $hW - $cbPad), $ly)
        }
    }
    $cbPen.Dispose()

    # ── 8. Pauldrons (shoulder plate) ─────────────────────
    $pdW = [int]($hW * 1.18)
    $pdH = [int]($size * 0.10)
    $pdY = [int]($bodyT + $bodyH - [int]($pdH * 0.32))
    $pdBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 48, 51, 60))
    $g.FillEllipse($pdBrush, ($cx - [int]($pdW/2)), $pdY, $pdW, $pdH)
    $pdBrush.Dispose()

    # Pauldron highlight
    $pdHiBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(28, 215, 228, 242))
    $g.FillEllipse($pdHiBrush, ($cx - [int]($pdW/2)), $pdY, $pdW, [int]($pdH*0.45))
    $pdHiBrush.Dispose()

    # ── 9. Helmet outline (dark rim, no gold) ─────────────
    $rimPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 22, 22, 26), [int]($size*0.014+1))
    $g.DrawEllipse($rimPen, $hLeft, $hTop, $hW, $domeH)
    $g.DrawEllipse($rimPen, ($cx - [int]($pdW/2)), $pdY, $pdW, $pdH)
    $rimPen.Dispose()

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Saved: $path ($size x $size)"
}

Make-Icon -size 512 -path 'C:\Users\tomhu\OneDrive\Documents\Claude\small scale project\icon-512.png'
Make-Icon -size 192 -path 'C:\Users\tomhu\OneDrive\Documents\Claude\small scale project\icon-192.png'
Make-Icon -size 180 -path 'C:\Users\tomhu\OneDrive\Documents\Claude\small scale project\icon-180.png'
Write-Host 'All icons generated!'

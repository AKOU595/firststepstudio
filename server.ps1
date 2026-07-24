$root = $PSScriptRoot
$port = 8000
$p = New-Object System.Net.HttpListener
$p.Prefixes.Add("http://localhost:$port/")
$p.Start()

$mime = @{
  ".html" = "text/html; charset=utf-8"
  ".css"  = "text/css"
  ".js"   = "application/javascript"
  ".mp4"  = "video/mp4"
  ".mov"  = "video/quicktime"
  ".otf"  = "font/otf"
  ".png"  = "image/png"
  ".jpg"  = "image/jpeg"
  ".svg"  = "image/svg+xml"
  ".ico"  = "image/x-icon"
  ".mp3"  = "audio/mpeg"
}

Write-Host "Server ready at http://localhost:$port"

while ($p.IsListening) {
  $c = $p.GetContext()
  try {
    $f = $c.Request.Url.AbsolutePath.TrimStart('/')
    if ([string]::IsNullOrEmpty($f)) { $f = "index.html" }
    $f = [Uri]::UnescapeDataString($f)
    $path = Join-Path $root $f
    if (Test-Path $path -PathType Leaf) {
      $bytes = [IO.File]::ReadAllBytes($path)
      $ext = [IO.Path]::GetExtension($path).ToLower()
      $ct = $mime[$ext]
      if (-not $ct) { $ct = "application/octet-stream" }
      $c.Response.ContentType = $ct
      $c.Response.ContentLength64 = $bytes.Length
      $c.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $c.Response.StatusCode = 404
    }
  } catch {
    $c.Response.StatusCode = 500
  }
  $c.Response.Close()
}
$p.Stop()

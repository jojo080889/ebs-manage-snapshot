BEGIN {
  now = systime()
  days_in_sec = days * 24 * 3600
}

$1 ~ /SNAPSHOT/ {
  split($5, ds, "T")
  split(ds[1], d, "-")
  split(ds[2], pretime, "+")
  split(pretime[1], t, ":")
  date           = d[1] " " d[2] " " d[3] " " t[1] " " t[2] " " t[3]
  age_in_seconds = mktime(date)

  if(now - age_in_seconds > days_in_sec)
    print $2 
}

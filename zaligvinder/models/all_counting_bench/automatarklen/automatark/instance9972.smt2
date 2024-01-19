(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Referer\u{3a}\s*?http\u{3a}\u{2f}{2}[a-z0-9\u{2e}\u{2d}]+\u{2f}s\u{2f}\u{3f}k\u{3d}/Hi
(assert (str.in_re X (re.++ (str.to_re "/Referer:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "http:") ((_ re.loop 2 2) (str.to_re "/")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/s/?k=/Hi\u{0a}"))))
; ^R(\d){8}
(assert (str.in_re X (re.++ (str.to_re "R") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \swww\.fast-finder\.com[^\n\r]*\x2Fbar_pl\x2Fchk\.fcgi\d+Toolbar
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/chk.fcgi") (re.+ (re.range "0" "9")) (str.to_re "Toolbar\u{0a}")))))
; TOOLBAR\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "TOOLBAR") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

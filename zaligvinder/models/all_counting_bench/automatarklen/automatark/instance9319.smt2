(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \swww\.fast-finder\.com[^\n\r]*\x2Fbar_pl\x2Fchk\.fcgi\d+Toolbar
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/chk.fcgi") (re.+ (re.range "0" "9")) (str.to_re "Toolbar\u{0a}")))))
; [a-zA-Z][a-zA-Z0-9_\-\,\.]{5,31}
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 5 31) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ",") (str.to_re "."))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

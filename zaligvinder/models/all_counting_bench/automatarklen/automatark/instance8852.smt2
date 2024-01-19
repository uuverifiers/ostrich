(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{9}[\d|X]$
(assert (not (str.in_re X (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "X")) (str.to_re "\u{0a}")))))
; PASSW=\w+www2\u{2e}instantbuzz\u{2e}com\x2Fbar_pl\x2Fchk_bar\.fcgi
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www2.instantbuzz.com/bar_pl/chk_bar.fcgi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

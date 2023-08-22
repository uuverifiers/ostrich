(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; URL\s+url=Host\u{3a}httpUser-Agent\x3ASubject\x3A
(assert (str.in_re X (re.++ (str.to_re "URL") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "url=Host:httpUser-Agent:Subject:\u{0a}"))))
; ^[A-Za-z]{3,4}[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; URL\s+\.cfgmPOPrtCUSTOMPalToolbarUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "URL") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".cfgmPOPrtCUSTOMPalToolbarUser-Agent:\u{0a}")))))
; Pleasetvshowticketsmedia\x2Edxcdirect\x2Ecom\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "Pleasetvshowticketsmedia.dxcdirect.com/bar_pl/chk.fcgi\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)

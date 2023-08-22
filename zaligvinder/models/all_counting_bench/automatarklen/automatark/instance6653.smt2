(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbarverpop\x2Epopuptoast\x2Ecomtvshowticketscount\x2Eyok\x2Ecom
(assert (not (str.in_re X (str.to_re "Toolbarverpop.popuptoast.comtvshowticketscount.yok.com\u{0a}"))))
; weatherSubject\u{3a}X-Mailer\u{3a}TOOLBAR\x2Fnewsurfer4\x2F
(assert (str.in_re X (str.to_re "weatherSubject:X-Mailer:\u{13}TOOLBAR/newsurfer4/\u{0a}")))
; ^([0-9]{4})([0-9]{5})([0-9]{1})$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[1-9]{3}\s{0,1}[0-9]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "1" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

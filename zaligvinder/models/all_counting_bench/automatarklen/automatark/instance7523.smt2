(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; X-Mailer\u{3a}[^\n\r]*Host\x3A\s+cyber@yahoo\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.com\u{0a}"))))
; /\u{28}compatible\u{3b}[A-Z]*\u{3b}\u{29}\u{0d}\u{0a}/H
(assert (str.in_re X (re.++ (str.to_re "/(compatible;") (re.* (re.range "A" "Z")) (str.to_re ";)\u{0d}\u{0a}/H\u{0a}"))))
; ^(\d{4})[.](0{0,1}[1-9]|1[012])[.](0{0,1}[1-9]|[12][0-9]|3[01])[.](\d{2})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\s+Boss\s+media\x2Etop-banners\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Boss") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.top-banners.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; &#\d{2,5};
(assert (str.in_re X (re.++ (str.to_re "&#") ((_ re.loop 2 5) (re.range "0" "9")) (str.to_re ";\u{0a}"))))
; SecureNet\sHost\x3AX-Mailer\x3Aas\x2Estarware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SecureNet") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:X-Mailer:\u{13}as.starware.com\u{0a}")))))
; body=\u{25}21\u{25}21\u{25}21Optix\s+Host\u{3a}
(assert (str.in_re X (re.++ (str.to_re "body=%21%21%21Optix\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; (^-\d*\.?\d*[1-9]+\d*$)|(^-[1-9]+\d*\.\d*$)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "-") (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}-") (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))))))
; ^((0[0-9])|(1[0-2])|(2[1-9])|(3[0-2])|(6[1-9])|(7[0-2])|80)([0-9]{7})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "2") (re.range "1" "9")) (re.++ (str.to_re "3") (re.range "0" "2")) (re.++ (str.to_re "6") (re.range "1" "9")) (re.++ (str.to_re "7") (re.range "0" "2")) (str.to_re "80")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

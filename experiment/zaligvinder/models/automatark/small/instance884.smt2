(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SecureNet\sHost\x3AX-Mailer\x3Aas\x2Estarware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SecureNet") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:X-Mailer:\u{13}as.starware.com\u{0a}")))))
; /\u{2f}Type\u{2f}XRef\u{2f}W\u{5b}[^\u{5d}]*?\d{7,15}/smi
(assert (not (str.in_re X (re.++ (str.to_re "//Type/XRef/W[") (re.* (re.comp (str.to_re "]"))) ((_ re.loop 7 15) (re.range "0" "9")) (str.to_re "/smi\u{0a}")))))
; wwwHost\u{3a}RobertVersionspyblini\x2Eini
(assert (not (str.in_re X (str.to_re "wwwHost:RobertVersionspyblini.ini\u{0a}"))))
(check-sat)

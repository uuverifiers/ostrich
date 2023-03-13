(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}pjpeg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pjpeg/i\u{0a}"))))
; ^(\+27|27|0)[0-9]{2}( |-)?[0-9]{3}( |-)?[0-9]{4}( |-)?(x[0-9]+)?(ext[0-9]+)?
(assert (not (str.in_re X (re.++ (re.union (str.to_re "+27") (str.to_re "27") (str.to_re "0")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.opt (re.++ (str.to_re "x") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "ext") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3AX-Mailer\x3Aas\x2Estarware\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:X-Mailer:\u{13}as.starware.com\u{0a}"))))
; body=\u{25}21\u{25}21\u{25}21Optix\s+Host\u{3a}
(assert (str.in_re X (re.++ (str.to_re "body=%21%21%21Optix\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; LoggerovplUser-Agent\x3At=searchreslt\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (str.to_re "LoggerovplUser-Agent:t=searchreslt}{Sysuptime:\u{0a}"))))
(check-sat)

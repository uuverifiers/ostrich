(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*Basic.*ProtoUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "Basic") (re.* re.allchar) (str.to_re "ProtoUser-Agent:\u{0a}")))))
; ^-?\d*(\.\d+)?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; [-+]((0[0-9]|1[0-3]):([03]0|45)|14:00)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "-") (str.to_re "+")) (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "3"))) (str.to_re ":") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "3")) (str.to_re "0")) (str.to_re "45"))) (str.to_re "14:00")) (str.to_re "\u{0a}")))))
; xpsp2-\s+spyblpat.*is\x2EphpBarFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "xpsp2-") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpat") (re.* re.allchar) (str.to_re "is.phpBarFrom:\u{0a}"))))
; /\.gif\u{3f}[a-f0-9]{4,7}\u{3d}\d{6,8}$/U
(assert (str.in_re X (re.++ (str.to_re "/.gif?") ((_ re.loop 4 7) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

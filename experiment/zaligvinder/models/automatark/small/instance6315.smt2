(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^.{2,}$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) re.allchar) (re.* re.allchar))))
; ^\d?\d'(\d|1[01])"$
(assert (not (str.in_re X (re.++ (re.opt (re.range "0" "9")) (re.range "0" "9") (str.to_re "'") (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{22}\u{0a}")))))
; [-+]?((\.[0-9]+|[0-9]+\.[0-9]+)([eE][-+][0-9]+)?|[0-9]+)
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ (re.union (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.union (str.to_re "-") (str.to_re "+")) (re.+ (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; User-Agent\x3A\s+GET\d+\x2Fcommunicatortb
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GET") (re.+ (re.range "0" "9")) (str.to_re "/communicatortb\u{0a}")))))
; SI\|Server\|\s+OSSProxy\x5Chome\/lordofsearch%3fAuthorization\u{3a}
(assert (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OSSProxy\u{5c}home/lordofsearch%3fAuthorization:\u{0a}"))))
(check-sat)

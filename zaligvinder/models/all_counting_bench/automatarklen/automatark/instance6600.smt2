(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <[^>]*?>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}"))))
; ^[\n <"';]*([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "<") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";"))) (str.to_re "\u{0a}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))))))
; YWRtaW46cGFzc3dvcmQ[^\n\r]*DA[^\n\r]*Host\x3Awww\x2Ee-finder\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "DA") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:www.e-finder.cc\u{0a}")))))
; /^<!--\s+[\w]{52,}\s+-->\r\n/smi
(assert (not (str.in_re X (re.++ (str.to_re "/<!--") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-->\u{0d}\u{0a}/smi\u{0a}") ((_ re.loop 52 52) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
(assert (> (str.len X) 10))
(check-sat)

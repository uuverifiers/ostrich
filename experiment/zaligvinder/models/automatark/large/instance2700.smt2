(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-3][0-9][0-1]\d{3}-\d{4}?
(assert (str.in_re X (re.++ (re.range "0" "3") (re.range "0" "9") (re.range "0" "1") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; url=http\x3A\s+jsp[^\n\r]*serverHOST\x3ASubject\x3Ai\-femdom\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "url=http:\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jsp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "serverHOST:Subject:i-femdom.com\u{0a}"))))
; /ID3\u{03}\u{00}.{5}([TW][A-Z]{3}|COMM)/smi
(assert (not (str.in_re X (re.++ (str.to_re "/ID3\u{03}\u{00}") ((_ re.loop 5 5) re.allchar) (re.union (re.++ (re.union (str.to_re "T") (str.to_re "W")) ((_ re.loop 3 3) (re.range "A" "Z"))) (str.to_re "COMM")) (str.to_re "/smi\u{0a}")))))
; yddznydqir\u{2f}eviaresflashdownloader\x2Ecom
(assert (str.in_re X (str.to_re "yddznydqir/eviaresflashdownloader.com\u{0a}")))
; /^\/[a-z0-9]{32}\/[a-z0-9]{32}\.jnlp/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jnlp/U\u{0a}"))))
(check-sat)

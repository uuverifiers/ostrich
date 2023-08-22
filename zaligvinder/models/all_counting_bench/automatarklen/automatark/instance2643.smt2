(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}"))))
; Login.*Host\x3A\s+Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (re.++ (str.to_re "Login") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}")))))
; /filename=[^\n]*\u{2e}xlsx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xlsx/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

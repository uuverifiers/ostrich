(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\d+O\d+\.jsp\?[a-z0-9\u{3d}\u{2b}\u{2f}]{20}/iR
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iR\u{0a}"))))
; /\u{2e}crx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.crx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; User-Agent\x3A.*OSSProxy
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "OSSProxy\u{0a}")))))
; attachedEverywareHELOBasic
(assert (not (str.in_re X (str.to_re "attachedEverywareHELOBasic\u{0a}"))))
; ^(\d{3}|\d{4})[-](\d{5})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)

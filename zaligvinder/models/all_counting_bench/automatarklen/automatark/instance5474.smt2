(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^1?[1-2]$|^[1-9]$|^[1]0$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "1")) (re.range "1" "2")) (re.range "1" "9") (str.to_re "10\u{0a}")))))
; /filename=[^\n]*\u{2e}m3u/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m3u/i\u{0a}")))))
; /\u{2e}dcr([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dcr") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(.)+\.(jpg|jpeg|JPG|JPEG)$
(assert (str.in_re X (re.++ (re.+ re.allchar) (str.to_re ".") (re.union (str.to_re "jpg") (str.to_re "jpeg") (str.to_re "JPG") (str.to_re "JPEG")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

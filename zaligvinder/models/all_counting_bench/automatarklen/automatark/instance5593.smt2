(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/ddd\/[a-z]{2}.gif/iU
(assert (not (str.in_re X (re.++ (str.to_re "//ddd/") ((_ re.loop 2 2) (re.range "a" "z")) re.allchar (str.to_re "gif/iU\u{0a}")))))
; /\u{2e}tte([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.tte") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; [0-9a-fA-F]+
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; Referer\x3A\s+www\u{2e}proventactics\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.com\u{0a}"))))
; ^([a-zA-Z0_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "0") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.union (re.++ (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".")))) (re.union ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 3) (re.range "0" "9"))) (re.opt (str.to_re "]")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

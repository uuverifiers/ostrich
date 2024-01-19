(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}smi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smi/i\u{0a}"))))
; /filename=[a-z]{5,8}\d{2,3}\.swf\u{0d}\u{0a}/Hm
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".swf\u{0d}\u{0a}/Hm\u{0a}")))))
; ^[A-Za-z]:\\([^"*/:?|<>\\.\u{00}-\u{20}]([^"*/:?|<>\\\u{00}-\x1F]*[^"*/:?|<>\\.\u{00}-\u{20}])?\\)*$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (str.to_re ":\u{5c}") (re.* (re.++ (re.union (str.to_re "\u{22}") (str.to_re "*") (str.to_re "/") (str.to_re ":") (str.to_re "?") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (str.to_re ".") (re.range "\u{00}" " ")) (re.opt (re.++ (re.* (re.union (str.to_re "\u{22}") (str.to_re "*") (str.to_re "/") (str.to_re ":") (str.to_re "?") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (re.range "\u{00}" "\u{1f}"))) (re.union (str.to_re "\u{22}") (str.to_re "*") (str.to_re "/") (str.to_re ":") (str.to_re "?") (str.to_re "|") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (str.to_re ".") (re.range "\u{00}" " ")))) (str.to_re "\u{5c}"))) (str.to_re "\u{0a}"))))
; /\u{2e}ppt([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ppt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

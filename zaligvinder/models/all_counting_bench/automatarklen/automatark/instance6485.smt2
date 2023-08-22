(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}aif[cf]?([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.aif") (re.opt (re.union (str.to_re "c") (str.to_re "f"))) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^-?(\d+(,\d{3})*(\.\d+)?|\d?(\.\d+))$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (re.opt (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; spas\s+This\s+\x7D\x7BPassword\x3A\s+OSSProxy\x5Chome\/lordofsearch
(assert (str.in_re X (re.++ (str.to_re "spas") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "This") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OSSProxy\u{5c}home/lordofsearch\u{0a}"))))
; ^.*(([^\.][\.][wW][mM][aA])|([^\.][\.][mM][pP][3]))$
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (re.++ (re.comp (str.to_re ".")) (str.to_re ".") (re.union (str.to_re "w") (str.to_re "W")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "a") (str.to_re "A"))) (re.++ (re.comp (str.to_re ".")) (str.to_re ".") (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "p") (str.to_re "P")) (str.to_re "3"))) (str.to_re "\u{0a}"))))
; /^\/\d+\/\d\.zip$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re "/") (re.range "0" "9") (str.to_re ".zip/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

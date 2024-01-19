(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9])|(1[0-2]))\/*((2011)|(20[1-9][1-9]))$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.* (str.to_re "/")) (re.union (str.to_re "2011") (re.++ (str.to_re "20") (re.range "1" "9") (re.range "1" "9"))) (str.to_re "\u{0a}"))))
; User-Agent\x3A\s+xbqyosoe\u{2f}cpvmAdToolsconnectedNodes
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "xbqyosoe/cpvmAdToolsconnectedNodes\u{0a}")))))
; [+-]?\d(\.\d+)?[Ee][+-]?\d+
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.union (str.to_re "E") (str.to_re "e")) (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}tif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tif/i\u{0a}"))))
; ^[\\(]{0,1}([0-9]){3}[\\)]{0,1}[ ]?([^0-1]){1}([0-9]){2}[ ]?[-]?[ ]?([0-9]){4}[ ]*((x){0,1}([0-9]){1,5}){0,1}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "\u{5c}") (str.to_re "("))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "\u{5c}") (str.to_re ")"))) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (str.to_re " ")) (re.opt (re.++ (re.opt (str.to_re "x")) ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

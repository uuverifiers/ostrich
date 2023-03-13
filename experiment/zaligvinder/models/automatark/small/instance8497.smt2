(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Dr[.]?|Phd[.]?|MBA/i
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/Dr") (re.opt (str.to_re "."))) (re.++ (str.to_re "Phd") (re.opt (str.to_re "."))) (str.to_re "MBA/i\u{0a}")))))
; ^([+]39)?((38[{8,9}|0])|(34[{7-9}|0])|(36[6|8|0])|(33[{3-9}|0])|(32[{8,9}]))([\d]{7})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+39")) (re.union (re.++ (str.to_re "38") (re.union (str.to_re "{") (str.to_re "8") (str.to_re ",") (str.to_re "9") (str.to_re "}") (str.to_re "|") (str.to_re "0"))) (re.++ (str.to_re "34") (re.union (str.to_re "{") (re.range "7" "9") (str.to_re "}") (str.to_re "|") (str.to_re "0"))) (re.++ (str.to_re "36") (re.union (str.to_re "6") (str.to_re "|") (str.to_re "8") (str.to_re "0"))) (re.++ (str.to_re "33") (re.union (str.to_re "{") (re.range "3" "9") (str.to_re "}") (str.to_re "|") (str.to_re "0"))) (re.++ (str.to_re "32") (re.union (str.to_re "{") (str.to_re "8") (str.to_re ",") (str.to_re "9") (str.to_re "}")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^("(\\["\\]|[^"])*"|[^\n])*$/gm
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (str.to_re "\u{0a}")))) (str.to_re "/gm\u{0a}"))))
; /filename=[^\n]*\u{2e}emf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".emf/i\u{0a}")))))
(check-sat)

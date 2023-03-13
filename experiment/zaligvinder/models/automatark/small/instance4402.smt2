(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Efreescratchandwin\x2Ecom\w+Port.*User-Agent\x3AToolbarkit
(assert (not (str.in_re X (re.++ (str.to_re "www.freescratchandwin.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Port") (re.* re.allchar) (str.to_re "User-Agent:Toolbarkit\u{0a}")))))
; ^\+?\(?\d+\)?(\s|\-|\.)?\d{1,3}(\s|\-|\.)?\d{4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re "(")) (re.+ (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \s*("[^"]+"|[^ ,]+)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.+ (re.union (str.to_re " ") (str.to_re ",")))) (str.to_re "\u{0a}"))))
; ^(V-|I-)?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "V-") (str.to_re "I-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[[V|E|J|G]\d\d\d\d\d\d\d\d]{0,9}$
(assert (str.in_re X (re.++ (re.union (str.to_re "[") (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G")) (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") ((_ re.loop 0 9) (str.to_re "]")) (str.to_re "\u{0a}"))))
(check-sat)

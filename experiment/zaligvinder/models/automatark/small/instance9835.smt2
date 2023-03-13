(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(\d{2}\x2E\d{3}\x2E\d{3}[-]\d{1})$|^(\d{2}\x2E\d{3}\x2E\d{3})$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; (<(!--.*|script)(.|\n[^<])*(--|script)>)|(<|<)(/?[\w!?]+)\s?[^<]*(>|>)|(\&[\w]+\;)
(assert (str.in_re X (re.union (re.++ (str.to_re "<") (re.union (re.++ (str.to_re "!--") (re.* re.allchar)) (str.to_re "script")) (re.* (re.union re.allchar (re.++ (str.to_re "\u{0a}") (re.comp (str.to_re "<"))))) (re.union (str.to_re "--") (str.to_re "script")) (str.to_re ">")) (re.++ (str.to_re "<") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re "<"))) (str.to_re ">") (re.opt (str.to_re "/")) (re.+ (re.union (str.to_re "!") (str.to_re "?") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ (str.to_re "\u{0a}&") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ";")))))
; (1 )?\d{3} \d{3}-\d{4}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "1 ")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Mirar_KeywordContent
(assert (not (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}"))))
(check-sat)

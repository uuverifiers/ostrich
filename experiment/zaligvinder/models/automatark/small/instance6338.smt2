(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\[b\])([^\[\]]+)(\[/b\])
(assert (not (str.in_re X (re.++ (str.to_re "[b]") (re.+ (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "[/b]\u{0a}")))))
; ^\$?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (re.opt (re.++ re.allchar (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^\d{1,2}((,)|(,25)|(,50)|(,5)|(,75)|(,0)|(,00))?$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re ",25") (str.to_re ",50") (str.to_re ",5") (str.to_re ",75") (str.to_re ",0") (str.to_re ",00"))) (str.to_re "\u{0a}"))))
(check-sat)

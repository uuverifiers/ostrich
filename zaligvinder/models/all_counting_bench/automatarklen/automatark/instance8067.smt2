(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3ASpyPORT-ischeck=Component
(assert (str.in_re X (str.to_re "User-Agent:SpyPORT-ischeck=Component\u{0a}")))
; ^(\d{1,3},)?(\d{3},)+\d{3}(\.\d*)?$|^(\d*)(\.\d*)?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) (re.+ (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9"))))) (re.++ (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

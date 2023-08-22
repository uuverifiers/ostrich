(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([A-Z]{1,2}[0-9][0-9A-Z]?)\ ([0-9][A-Z]{2}))|(GIR\ 0AA)
(assert (not (str.in_re X (re.union (re.++ (str.to_re " ") ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))) (str.to_re "GIR 0AA\u{0a}")))))
; ^((http|https|ftp):\/\/)?((.*?):(.*?)@)?([a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])((\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])*)(:([0-9]{1,5}))?((\/.*?)(\?(.*?))?(\#(.*))?)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp")) (str.to_re "://"))) (re.opt (re.++ (re.* re.allchar) (str.to_re ":") (re.* re.allchar) (str.to_re "@"))) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (re.opt (re.++ (re.opt (re.++ (str.to_re "?") (re.* re.allchar))) (re.opt (re.++ (str.to_re "#") (re.* re.allchar))) (str.to_re "/") (re.* re.allchar))) (str.to_re "\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)

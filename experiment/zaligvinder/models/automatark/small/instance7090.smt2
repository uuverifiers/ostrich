(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; fsbuffsearch\u{2e}conduit\u{2e}comocllceclbhs\u{2f}gth
(assert (str.in_re X (str.to_re "fsbuffsearch.conduit.comocllceclbhs/gth\u{0a}")))
; ^[http|ftp|wap|https]{3,5}:\//\www\.\w*\.[com|net]{2,3}$
(assert (str.in_re X (re.++ ((_ re.loop 3 5) (re.union (str.to_re "h") (str.to_re "t") (str.to_re "p") (str.to_re "|") (str.to_re "f") (str.to_re "w") (str.to_re "a") (str.to_re "s"))) (str.to_re "://") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re "ww.") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "c") (str.to_re "o") (str.to_re "m") (str.to_re "|") (str.to_re "n") (str.to_re "e") (str.to_re "t"))) (str.to_re "\u{0a}"))))
; ^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K"))) (str.to_re "\u{0a}")))))
; /\u{2e}wri([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wri") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)

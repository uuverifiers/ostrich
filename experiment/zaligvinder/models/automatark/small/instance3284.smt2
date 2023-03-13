(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{0,2}(\.\d{1,4})? *%?$
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))
; http://www.9lessons.info/2008/08/most-popular-articles.html
(assert (str.in_re X (re.++ (str.to_re "http://www") re.allchar (str.to_re "9lessons") re.allchar (str.to_re "info/2008/08/most-popular-articles") re.allchar (str.to_re "html\u{0a}"))))
(check-sat)

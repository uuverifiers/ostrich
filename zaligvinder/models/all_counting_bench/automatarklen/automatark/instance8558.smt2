(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Edat\x2EToolbar\x7D\x7BOS\x3Atoolsbar\x2Ekuaiso\x2Ecom
(assert (str.in_re X (str.to_re ".dat.Toolbar}{OS:toolsbar.kuaiso.com\u{0a}")))
; ([(]?\d{3}[)]?(-| |.)?\d{3}(-| |.)?\d{4})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9"))))))
; /^images.php\?t=\d{2,7}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/images") re.allchar (str.to_re "php?t=") ((_ re.loop 2 7) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; /\u{2e}cnt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.cnt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; @{2}((\S)+)@{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "@")) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 2 2) (str.to_re "@")) (str.to_re "\u{0a}")))))
; www\.thecommunicator\.net\d+http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (not (str.in_re X (re.++ (str.to_re "www.thecommunicator.net") (re.+ (re.range "0" "9")) (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))))
; Mirar_KeywordContent
(assert (not (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

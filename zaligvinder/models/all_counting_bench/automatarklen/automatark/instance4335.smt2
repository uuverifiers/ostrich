(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ConnectionUser-Agent\x3A\swww\.fast-finder\.com
(assert (not (str.in_re X (re.++ (str.to_re "ConnectionUser-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com\u{0a}")))))
; rank\x2Etoolbarbrowser\x2Ecomlnzzlnbk\u{2f}pkrm\.fin
(assert (str.in_re X (str.to_re "rank.toolbarbrowser.comlnzzlnbk/pkrm.fin\u{0a}")))
; Subject\x3AAlexaOnline\u{25}21\u{25}21\u{25}21
(assert (not (str.in_re X (str.to_re "Subject:AlexaOnline%21%21%21\u{0a}"))))
; /^\/blog\/[a-zA-Z0-9]{3}\.(g(3|e)d|mm|vru|be|nut)$/U
(assert (str.in_re X (re.++ (str.to_re "//blog/") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".") (re.union (re.++ (str.to_re "g") (re.union (str.to_re "3") (str.to_re "e")) (str.to_re "d")) (str.to_re "mm") (str.to_re "vru") (str.to_re "be") (str.to_re "nut")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; isiz=Xtrastepwebhancer\x2EcomStubbyOnever\u{3a}Ghost
(assert (str.in_re X (str.to_re "isiz=Xtrastepwebhancer.comStubbyOnever:Ghost\u{13}\u{0a}")))
; /\)\r\nHost\u{3a}\u{20}[a-z\d\u{2e}\u{2d}]{6,32}\r\nCache\u{2d}Control\u{3a}\u{20}no\u{2d}cache\r\n\r\n$/
(assert (str.in_re X (re.++ (str.to_re "/)\u{0d}\u{0a}Host: ") ((_ re.loop 6 32) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{0d}\u{0a}Cache-Control: no-cache\u{0d}\u{0a}\u{0d}\u{0a}/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)

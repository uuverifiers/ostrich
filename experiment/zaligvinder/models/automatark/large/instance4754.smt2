(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; forum=\s+\x2Ftoolbar\x2Fico\x2F
(assert (not (str.in_re X (re.++ (str.to_re "forum=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}")))))
; .*[\$Ss]pecia[l1]\W[Oo0]ffer.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "$") (str.to_re "S") (str.to_re "s")) (str.to_re "pecia") (re.union (str.to_re "l") (str.to_re "1")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "O") (str.to_re "o") (str.to_re "0")) (str.to_re "ffer") (re.* re.allchar) (str.to_re "\u{0a}")))))
; cyber@yahoo\x2Ecom\s+WindowsAttachedPalas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (str.in_re X (re.++ (str.to_re "cyber@yahoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WindowsAttachedPalas.starware.com/dp/search?x=\u{0a}"))))
; <[iI][mM][gG]([^>]*[^/>]*[/>]*[>])
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "g") (str.to_re "G")) (str.to_re "\u{0a}") (re.* (re.comp (str.to_re ">"))) (re.* (re.union (str.to_re "/") (str.to_re ">"))) (re.* (re.union (str.to_re "/") (str.to_re ">"))) (str.to_re ">")))))
; /SOAPAction\x3A\s*?\u{22}[^\u{22}\u{23}]+?\u{23}([^\u{22}]{2048}|[^\u{22}]+$)/Hsi
(assert (not (str.in_re X (re.++ (str.to_re "/SOAPAction:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.+ (re.union (str.to_re "\u{22}") (str.to_re "#"))) (str.to_re "#") (re.union ((_ re.loop 2048 2048) (re.comp (str.to_re "\u{22}"))) (re.+ (re.comp (str.to_re "\u{22}")))) (str.to_re "/Hsi\u{0a}")))))
(check-sat)

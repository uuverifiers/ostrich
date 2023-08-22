(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}qcp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qcp/i\u{0a}"))))
; ^([-+]?(\d+\.?\d*|\d*\.?\d+)([Ee][-+]?[0-2]?\d{1,2})?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.range "0" "2")) ((_ re.loop 1 2) (re.range "0" "9")))))))
; Strip-Player.*MyAgent.*\x2Fnewsurfer4\x2F
(assert (str.in_re X (re.++ (str.to_re "Strip-Player\u{1b}") (re.* re.allchar) (str.to_re "MyAgent") (re.* re.allchar) (str.to_re "/newsurfer4/\u{0a}"))))
; ^([a-z-[dfioquwz]]|[A-Z-[DFIOQUWZ]])\d([a-z-[dfioqu]]|[A-Z-[DFIOQU]])(\s)?\d([a-z-[dfioqu]]|[A-Z-[DFIOQU]])\d$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "[") (str.to_re "d") (str.to_re "f") (str.to_re "i") (str.to_re "o") (str.to_re "q") (str.to_re "u") (str.to_re "w") (str.to_re "z")) (str.to_re "]")) (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U") (str.to_re "W") (str.to_re "Z")) (str.to_re "]"))) (re.range "0" "9") (re.union (re.++ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "[") (str.to_re "d") (str.to_re "f") (str.to_re "i") (str.to_re "o") (str.to_re "q") (str.to_re "u")) (str.to_re "]")) (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U")) (str.to_re "]"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.union (re.++ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "[") (str.to_re "d") (str.to_re "f") (str.to_re "i") (str.to_re "o") (str.to_re "q") (str.to_re "u")) (str.to_re "]")) (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U")) (str.to_re "]"))) (re.range "0" "9") (str.to_re "\u{0a}")))))
; Subject\x3Aas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (str.in_re X (str.to_re "Subject:as.starware.com/dp/search?x=\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)

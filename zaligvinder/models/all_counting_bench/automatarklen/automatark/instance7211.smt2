(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <h([1-6])>([^<]*)</h([1-6])>
(assert (not (str.in_re X (re.++ (str.to_re "<h") (re.range "1" "6") (str.to_re ">") (re.* (re.comp (str.to_re "<"))) (str.to_re "</h") (re.range "1" "6") (str.to_re ">\u{0a}")))))
; hirmvtg\u{2f}ggqh\.kqh\w+whenu\x2Ecom\w+weatherHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "whenu.com\u{13}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "weatherHost:User-Agent:\u{0a}")))))
; dll\x3F\[DRIVEHost\x3A\u{b0}\u{ae}\u{b6}\u{f9}\u{cd}\u{f8}\u{b5}\u{c1}
(assert (not (str.in_re X (str.to_re "dll?[DRIVEHost:\u{b0}\u{ae}\u{b6}\u{f9}\u{cd}\u{f8}\u{b5}\u{c1}\u{0a}"))))
; /^Referer\u{3a}[^\r\n]+\/[\w_]{32,}\.html\r$/Hsm
(assert (not (str.in_re X (re.++ (str.to_re "/Referer:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/.html\u{0d}/Hsm\u{0a}") ((_ re.loop 32 32) (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
(assert (> (str.len X) 10))
(check-sat)

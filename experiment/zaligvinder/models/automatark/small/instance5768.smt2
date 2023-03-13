(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; SpyBuddySubject\x3Astats\u{2e}drivecleaner\u{2e}com
(assert (not (str.in_re X (str.to_re "SpyBuddySubject:stats.drivecleaner.com\u{13}\u{0a}"))))
; /\u{2e}m4p([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.m4p") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (<meta [.\w\W]*?\>)|(<style [.\w\W]*?</style>)|(<link [.\w\W]*?\>)|(<script [.\w\W]*?</script>)
(assert (str.in_re X (re.union (re.++ (str.to_re "<meta ") (re.* (re.union (str.to_re ".") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ">")) (re.++ (str.to_re "<style ") (re.* (re.union (str.to_re ".") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "</style>")) (re.++ (str.to_re "<link ") (re.* (re.union (str.to_re ".") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ">")) (re.++ (str.to_re "\u{0a}<script ") (re.* (re.union (str.to_re ".") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "</script>")))))
; /Referer\u{3a}\u{20}[^\s]*\u{3a}8000\u{2f}[a-z]+\?[a-z]+=\d{6,7}\u{0d}\u{0a}/H
(assert (str.in_re X (re.++ (str.to_re "/Referer: ") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":8000/") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/H\u{0a}"))))
(check-sat)

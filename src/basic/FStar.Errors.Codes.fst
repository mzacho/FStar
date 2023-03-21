(*
   Copyright 2008-2020 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
module FStar.Errors.Codes

let default_settings : list error_setting =
  [
    Error_DependencyAnalysisFailed                    , CAlwaysError, 0;
    Error_IDETooManyPops                              , CAlwaysError, 1;
    Error_IDEUnrecognized                             , CAlwaysError, 2;
    Error_InductiveTypeNotSatisfyPositivityCondition  , CAlwaysError, 3;
    Error_InvalidUniverseVar                          , CAlwaysError, 4;
    Error_MissingFileName                             , CAlwaysError, 5;
    Error_ModuleFileNameMismatch                      , CAlwaysError, 6;
    Error_OpPlusInUniverse                            , CAlwaysError, 7;
    Error_OutOfRange                                  , CAlwaysError, 8;
    Error_ProofObligationFailed                       , CError, 9;
    Error_TooManyFiles                                , CAlwaysError, 10;
    Error_TypeCheckerFailToProve                      , CAlwaysError, 11;
    Error_TypeError                                   , CAlwaysError, 12;
    Error_UncontrainedUnificationVar                  , CAlwaysError, 13;
    Error_UnexpectedGTotComputation                   , CAlwaysError, 14;
    Error_UnexpectedInstance                          , CAlwaysError, 15;
    Error_UnknownFatal_AssertionFailure               , CError, 16;
    Error_Z3InvocationError                           , CAlwaysError, 17;
    Error_IDEAssertionFailure                         , CAlwaysError, 18;
    Error_Z3SolverError                               , CError, 19;
    Fatal_AbstractTypeDeclarationInInterface          , CFatal, 20;
    Fatal_ActionMustHaveFunctionType                  , CFatal, 21;
    Fatal_AlreadyDefinedTopLevelDeclaration           , CFatal, 22;
    Fatal_ArgumentLengthMismatch                      , CFatal, 23;
    Fatal_AssertionFailure                            , CFatal, 24;
    Fatal_AssignToImmutableValues                     , CFatal, 25;
    Fatal_AssumeValInInterface                        , CFatal, 26;
    Fatal_BadlyInstantiatedSynthByTactic              , CFatal, 27;
    Fatal_BadSignatureShape                           , CFatal, 28;
    Fatal_BinderAndArgsLengthMismatch                 , CFatal, 29;
    Fatal_BothValAndLetInInterface                    , CFatal, 30;
    Fatal_CardinalityConstraintViolated               , CFatal, 31;
    Fatal_ComputationNotTotal                         , CFatal, 32;
    Fatal_ComputationTypeNotAllowed                   , CFatal, 33;
    Fatal_ComputedTypeNotMatchAnnotation              , CFatal, 34;
    Fatal_ConstructorArgLengthMismatch                , CFatal, 35;
    Fatal_ConstructorFailedCheck                      , CFatal, 36;
    Fatal_ConstructorNotFound                         , CFatal, 37;
    Fatal_ConstsructorBuildWrongType                  , CFatal, 38;
    Fatal_CycleInRecTypeAbbreviation                  , CFatal, 39;
    Fatal_DataContructorNotFound                      , CFatal, 40;
    Fatal_DefaultQualifierNotAllowedOnEffects         , CFatal, 41;
    Fatal_DefinitionNotFound                          , CFatal, 42;
    Fatal_DisjuctivePatternVarsMismatch               , CFatal, 43;
    Fatal_DivergentComputationCannotBeIncludedInTotal , CFatal, 44;
    Fatal_DuplicateInImplementation                   , CFatal, 45;
    Fatal_DuplicateModuleOrInterface                  , CFatal, 46;
    Fatal_DuplicateTopLevelNames                      , CFatal, 47;
    Fatal_DuplicateTypeAnnotationAndValDecl           , CFatal, 48;
    Fatal_EffectCannotBeReified                       , CFatal, 49;
    Fatal_EffectConstructorNotFullyApplied            , CFatal, 50;
    Fatal_EffectfulAndPureComputationMismatch         , CFatal, 51;
    Fatal_EffectNotFound                              , CFatal, 52;
    Fatal_EffectsCannotBeComposed                     , CFatal, 53;
    Fatal_ErrorInSolveDeferredConstraints             , CFatal, 54;
    Fatal_ErrorsReported                              , CFatal, 55;
    Fatal_EscapedBoundVar                             , CFatal, 56;
    Fatal_ExpectedArrowAnnotatedType                  , CFatal, 57;
    Fatal_ExpectedGhostExpression                     , CFatal, 58;
    Fatal_ExpectedPureExpression                      , CFatal, 59;
    Fatal_ExpectNormalizedEffect                      , CFatal, 60;
    Fatal_ExpectTermGotFunction                       , CFatal, 61;
    Fatal_ExpectTrivialPreCondition                   , CFatal, 62;
    Fatal_FailToExtractNativeTactic                   , CFatal, 63;
    Fatal_FailToCompileNativeTactic                   , CFatal, 64;
    Fatal_FailToProcessPragma                         , CFatal, 65;
    Fatal_FailToResolveImplicitArgument               , CFatal, 66;
    Fatal_FailToSolveUniverseInEquality               , CFatal, 67;
    Fatal_FieldsNotBelongToSameRecordType             , CFatal, 68;
    Fatal_ForbiddenReferenceToCurrentModule           , CFatal, 69;
    Fatal_FreeVariables                               , CFatal, 70;
    Fatal_FunctionTypeExpected                        , CFatal, 71;
    Fatal_IdentifierNotFound                          , CFatal, 72;
    Fatal_IllAppliedConstant                          , CFatal, 73;
    Fatal_IllegalCharInByteArray                      , CFatal, 74;
    Fatal_IllegalCharInOperatorName                   , CFatal, 75;
    Fatal_IllTyped                                    , CFatal, 76;
    Fatal_ImpossibleAbbrevLidBundle                   , CFatal, 77;
    Fatal_ImpossibleAbbrevRenameBundle                , CFatal, 78;
    Fatal_ImpossibleInductiveWithAbbrev               , CFatal, 79;
    Fatal_ImpossiblePrePostAbs                        , CFatal, 80;
    Fatal_ImpossiblePrePostArrow                      , CFatal, 81;
    Fatal_ImpossibleToGenerateDMEffect                , CFatal, 82;
    Fatal_ImpossibleTypeAbbrevBundle                  , CFatal, 83;
    Fatal_ImpossibleTypeAbbrevSigeltBundle            , CFatal, 84;
    Fatal_IncludeModuleNotPrepared                    , CFatal, 85;
    Fatal_IncoherentInlineUniverse                    , CFatal, 86;
    Fatal_IncompatibleKinds                           , CFatal, 87;
    Fatal_IncompatibleNumberOfTypes                   , CFatal, 88;
    Fatal_IncompatibleSetOfUniverse                   , CFatal, 89;
    Fatal_IncompatibleUniverse                        , CFatal, 90;
    Fatal_InconsistentImplicitArgumentAnnotation      , CFatal, 91;
    Fatal_InconsistentImplicitQualifier               , CFatal, 92;
    Fatal_InconsistentQualifierAnnotation             , CFatal, 93;
    Fatal_InferredTypeCauseVarEscape                  , CFatal, 94;
    Fatal_InlineRenamedAsUnfold                       , CFatal, 95;
    Fatal_InsufficientPatternArguments                , CFatal, 96;
    Fatal_InterfaceAlreadyProcessed                   , CFatal, 97;
    Fatal_InterfaceNotImplementedByModule             , CFatal, 98;
    Fatal_InterfaceWithTypeImplementation             , CFatal, 99;
    Fatal_InvalidFloatingPointNumber                  , CFatal, 100;
    Fatal_InvalidFSDocKeyword                         , CFatal, 101;
    Fatal_InvalidIdentifier                           , CFatal, 102;
    Fatal_InvalidLemmaArgument                        , CFatal, 103;
    Fatal_InvalidNumericLiteral                       , CFatal, 104;
    Fatal_InvalidRedefinitionOfLexT                   , CFatal, 105;
    Fatal_InvalidUnicodeInStringLiteral               , CFatal, 106;
    Fatal_InvalidUTF8Encoding                         , CFatal, 107;
    Fatal_InvalidWarnErrorSetting                     , CFatal, 108;
    Fatal_LetBoundMonadicMismatch                     , CFatal, 109;
    Fatal_LetMutableForVariablesOnly                  , CFatal, 110;
    Fatal_LetOpenModuleOnly                           , CFatal, 111;
    Fatal_LetRecArgumentMismatch                      , CFatal, 112;
    Fatal_MalformedActionDeclaration                  , CFatal, 113;
    Fatal_MismatchedPatternType                       , CFatal, 114;
    Fatal_MismatchUniversePolymorphic                 , CFatal, 115;
    Fatal_MissingDataConstructor                      , CFatal, 116;
    Fatal_MissingExposeInterfacesOption               , CFatal, 117;
    Fatal_MissingFieldInRecord                        , CFatal, 118;
    Fatal_MissingImplementation                       , CFatal, 119;
    Fatal_MissingImplicitArguments                    , CFatal, 120;
    Fatal_MissingInterface                            , CFatal, 121;
    Fatal_MissingNameInBinder                         , CFatal, 122;
    Fatal_MissingPrimsModule                          , CFatal, 123;
    Fatal_MissingQuantifierBinder                     , CFatal, 124;
    Fatal_ModuleExpected                              , CFatal, 125;
    Fatal_ModuleFileNotFound                          , CFatal, 126;
    Fatal_ModuleFirstStatement                        , CFatal, 127;
    Fatal_ModuleNotFound                              , CFatal, 128;
    Fatal_ModuleOrFileNotFound                        , CFatal, 129;
    Fatal_MonadAlreadyDefined                         , CFatal, 130;
    Fatal_MoreThanOneDeclaration                      , CFatal, 131;
    Fatal_MultipleLetBinding                          , CFatal, 132;
    Fatal_NameNotFound                                , CFatal, 133;
    Fatal_NameSpaceNotFound                           , CFatal, 134;
    Fatal_NegativeUniverseConstFatal_NotSupported     , CFatal, 135;
    Fatal_NoFileProvided                              , CFatal, 136;
    Fatal_NonInductiveInMutuallyDefinedType           , CFatal, 137;
    Fatal_NonLinearPatternNotPermitted                , CFatal, 138;
    Fatal_NonLinearPatternVars                        , CFatal, 139;
    Fatal_NonSingletonTopLevel                        , CFatal, 140;
    Fatal_NonSingletonTopLevelModule                  , CFatal, 141;
    Error_NonTopRecFunctionNotFullyEncoded            , CError, 142;
    Fatal_NonTrivialPreConditionInPrims               , CFatal, 143;
    Fatal_NonVariableInductiveTypeParameter           , CFatal, 144;
    Fatal_NotApplicationOrFv                          , CFatal, 145;
    Fatal_NotEnoughArgsToEffect                       , CFatal, 146;
    Fatal_NotEnoughArgumentsForEffect                 , CFatal, 147;
    Fatal_NotFunctionType                             , CFatal, 148;
    Fatal_NotSupported                                , CFatal, 149;
    Fatal_NotTopLevelModule                           , CFatal, 150;
    Fatal_NotValidFStarFile                           , CFatal, 151;
    Fatal_NotValidIncludeDirectory                    , CFatal, 152;
    Fatal_OneModulePerFile                            , CFatal, 153;
    Fatal_OpenGoalsInSynthesis                        , CFatal, 154;
    Fatal_OptionsNotCompatible                        , CFatal, 155;
    Fatal_OutOfOrder                                  , CFatal, 156;
    Fatal_ParseErrors                                 , CFatal, 157;
    Fatal_ParseItError                                , CFatal, 158;
    Fatal_PolyTypeExpected                            , CFatal, 159;
    Fatal_PossibleInfiniteTyp                         , CFatal, 160;
    Fatal_PreModuleMismatch                           , CFatal, 161;
    Fatal_QulifierListNotPermitted                    , CFatal, 162;
    Fatal_RecursiveFunctionLiteral                    , CFatal, 163;
    Fatal_ReflectOnlySupportedOnEffects               , CFatal, 164;
    Fatal_ReservedPrefix                              , CFatal, 165;
    Fatal_SMTOutputParseError                         , CFatal, 166;
    Fatal_SMTSolverError                              , CFatal, 167;
    Fatal_SyntaxError                                 , CFatal, 168;
    Fatal_SynthByTacticError                          , CFatal, 169;
    Fatal_TacticGotStuck                              , CFatal, 170;
    Fatal_TcOneFragmentFailed                         , CFatal, 171;
    Fatal_TermOutsideOfDefLanguage                    , CFatal, 172;
    Fatal_ToManyArgumentToFunction                    , CFatal, 173;
    Fatal_TooManyOrTooFewFileMatch                    , CFatal, 174;
    Fatal_TooManyPatternArguments                     , CFatal, 175;
    Fatal_TooManyUniverse                             , CFatal, 176;
    Fatal_TypeMismatch                                , CFatal, 177;
    Fatal_TypeWithinPatternsAllowedOnVariablesOnly    , CFatal, 178;
    Fatal_UnableToReadFile                            , CFatal, 179;
    Fatal_UnepxectedOrUnboundOperator                 , CFatal, 180;
    Fatal_UnexpectedBinder                            , CFatal, 181;
    Fatal_UnexpectedBindShape                         , CFatal, 182;
    Fatal_UnexpectedChar                              , CFatal, 183;
    Fatal_UnexpectedComputationTypeForLetRec          , CFatal, 184;
    Fatal_UnexpectedConstructorType                   , CFatal, 185;
    Fatal_UnexpectedDataConstructor                   , CFatal, 186;
    Fatal_UnexpectedEffect                            , CFatal, 187;
    Fatal_UnexpectedEmptyRecord                       , CFatal, 188;
    Fatal_UnexpectedExpressionType                    , CFatal, 189;
    Fatal_UnexpectedFunctionParameterType             , CFatal, 190;
    Fatal_UnexpectedGeneralizedUniverse               , CFatal, 191;
    Fatal_UnexpectedGTotForLetRec                     , CFatal, 192;
    Fatal_UnexpectedGuard                             , CFatal, 193;
    Fatal_UnexpectedIdentifier                        , CFatal, 194;
    Fatal_UnexpectedImplicitArgument                  , CFatal, 195;
    Fatal_UnexpectedImplictArgument                   , CFatal, 196;
    Fatal_UnexpectedInductivetype                     , CFatal, 197;
    Fatal_UnexpectedLetBinding                        , CFatal, 198;
    Fatal_UnexpectedModuleDeclaration                 , CFatal, 199;
    Fatal_UnexpectedNumberOfUniverse                  , CFatal, 200;
    Fatal_UnexpectedNumericLiteral                    , CFatal, 201;
    Fatal_UnexpectedPattern                           , CFatal, 203;
    Fatal_UnexpectedPosition                          , CFatal, 204;
    Fatal_UnExpectedPreCondition                      , CFatal, 205;
    Fatal_UnexpectedReturnShape                       , CFatal, 206;
    Fatal_UnexpectedSignatureForMonad                 , CFatal, 207;
    Fatal_UnexpectedTerm                              , CFatal, 208;
    Fatal_UnexpectedTermInUniverse                    , CFatal, 209;
    Fatal_UnexpectedTermType                          , CFatal, 210;
    Fatal_UnexpectedTermVQuote                        , CFatal, 211;
    Fatal_UnexpectedUniversePolymorphicReturn         , CFatal, 212;
    Fatal_UnexpectedUniverseVariable                  , CFatal, 213;
    Fatal_UnfoldableDeprecated                        , CFatal, 214;
    Fatal_UnificationNotWellFormed                    , CFatal, 215;
    Fatal_Uninstantiated                              , CFatal, 216;
    Error_UninstantiatedUnificationVarInTactic        , CError, 217;
    Fatal_UninstantiatedVarInTactic                   , CFatal, 218;
    Fatal_UniverseMightContainSumOfTwoUnivVars        , CFatal, 219;
    Fatal_UniversePolymorphicInnerLetBound            , CFatal, 220;
    Fatal_UnknownAttribute                            , CFatal, 221;
    Fatal_UnknownToolForDep                           , CFatal, 222;
    Fatal_UnrecognizedExtension                       , CFatal, 223;
    Fatal_UnresolvedPatternVar                        , CFatal, 224;
    Fatal_UnsupportedConstant                         , CFatal, 225;
    Fatal_UnsupportedDisjuctivePatterns               , CFatal, 226;
    Fatal_UnsupportedQualifier                        , CFatal, 227;
    Fatal_UserTacticFailure                           , CFatal, 228;
    Fatal_ValueRestriction                            , CFatal, 229;
    Fatal_VariableNotFound                            , CFatal, 230;
    Fatal_WrongBodyTypeForReturnWP                    , CFatal, 231;
    Fatal_WrongDataAppHeadFormat                      , CFatal, 232;
    Fatal_WrongDefinitionOrder                        , CFatal, 233;
    Fatal_WrongResultTypeAfterConstrutor              , CFatal, 234;
    Fatal_WrongTerm                                   , CFatal, 235;
    Fatal_WhenClauseNotSupported                      , CFatal, 236;
    Unused01                                          , CFatal, 237;
    Warning_PluginNotImplemented                      , CError, 238;
    Warning_AddImplicitAssumeNewQualifier             , CWarning, 239;
    Warning_AdmitWithoutDefinition                    , CWarning, 240;
    Warning_CachedFile                                , CWarning, 241;
    Warning_DefinitionNotTranslated                   , CWarning, 242;
    Warning_DependencyFound                           , CWarning, 243;
    Warning_DeprecatedEqualityOnBinder                , CWarning, 244;
    Warning_DeprecatedOpaqueQualifier                 , CWarning, 245;
    Warning_DocOverwrite                              , CWarning, 246;
    Warning_FileNotWritten                            , CWarning, 247;
    Warning_Filtered                                  , CWarning, 248;
    Warning_FunctionLiteralPrecisionLoss              , CWarning, 249;
    Warning_FunctionNotExtacted                       , CWarning, 250;
    Warning_HintFailedToReplayProof                   , CWarning, 251;
    Warning_HitReplayFailed                           , CWarning, 252;
    Warning_IDEIgnoreCodeGen                          , CWarning, 253;
    Warning_IllFormedGoal                             , CWarning, 254;
    Warning_InaccessibleArgument                      , CWarning, 255;
    Warning_IncoherentImplicitQualifier               , CWarning, 256;
    Warning_IrrelevantQualifierOnArgumentToReflect    , CWarning, 257;
    Warning_IrrelevantQualifierOnArgumentToReify      , CWarning, 258;
    Warning_MalformedWarnErrorList                    , CWarning, 259;
    Warning_MetaAlienNotATmUnknown                    , CWarning, 260;
    Warning_MultipleAscriptions                       , CWarning, 261;
    Warning_NondependentUserDefinedDataType           , CWarning, 262;
    Warning_NonListLiteralSMTPattern                  , CWarning, 263;
    Warning_NormalizationFailure                      , CWarning, 264;
    Warning_NotDependentArrow                         , CWarning, 265;
    Warning_NotEmbedded                               , CWarning, 266;
    Warning_PatternMissingBoundVar                    , CWarning, 267;
    Warning_RecursiveDependency                       , CWarning, 268;
    Warning_RedundantExplicitCurrying                 , CWarning, 269;
    Warning_SMTPatTDeprecated                         , CWarning, 270;
    Warning_SMTPatternIllFormed                       , CWarning, 271;
    Warning_TopLevelEffect                            , CWarning, 272;
    Warning_UnboundModuleReference                    , CWarning, 273;
    Warning_UnexpectedFile                            , CWarning, 274;
    Warning_UnexpectedFsTypApp                        , CWarning, 275;
    Warning_UnexpectedZ3Output                        , CError, 276;
    Warning_UnprotectedTerm                           , CWarning, 277;
    Warning_UnrecognizedAttribute                     , CWarning, 278;
    Warning_UpperBoundCandidateAlreadyVisited         , CWarning, 279;
    Warning_UseDefaultEffect                          , CWarning, 280;
    Warning_WrongErrorLocation                        , CWarning, 281;
    Warning_Z3InvocationWarning                       , CWarning, 282;
    Warning_MissingInterfaceOrImplementation          , CWarning, 283;
    Warning_ConstructorBuildsUnexpectedType           , CWarning, 284;
    Warning_ModuleOrFileNotFoundWarning               , CWarning, 285;
    Error_NoLetMutable                                , CAlwaysError, 286;
    Error_BadImplicit                                 , CAlwaysError, 287;
    Warning_DeprecatedDefinition                      , CWarning, 288;
    Fatal_SMTEncodingArityMismatch                    , CFatal, 289;
    Warning_Defensive                                 , CWarning, 290;
    Warning_CantInspect                               , CWarning, 291;
    Warning_NilGivenExplicitArgs                      , CWarning, 292;
    Warning_ConsAppliedExplicitArgs                   , CWarning, 293;
    Warning_UnembedBinderKnot                         , CWarning, 294;
    Fatal_TacticProofRelevantGoal                     , CFatal, 295;
    Warning_TacAdmit                                  , CWarning, 296;
    Fatal_IncoherentPatterns                          , CFatal, 297;
    Error_NoSMTButNeeded                              , CAlwaysError, 298;
    Fatal_UnexpectedAntiquotation                     , CFatal, 299;
    Fatal_SplicedUndef                                , CFatal, 300;
    Fatal_SpliceUnembedFail                           , CFatal, 301;
    Warning_ExtractionUnexpectedEffect                , CWarning, 302;
    Error_DidNotFail                                  , CError, 303;
    Warning_UnappliedFail                             , CWarning, 304;
    Warning_QuantifierWithoutPattern                  , CSilent, 305;
    Error_EmptyFailErrs                               , CAlwaysError, 306;
    Warning_logicqualifier                            , CWarning, 307;
    Fatal_CyclicDependence                            , CFatal, 308;
    Error_InductiveAnnotNotAType                      , CError, 309;
    Fatal_FriendInterface                             , CFatal, 310;
    Error_CannotRedefineConst                         , CError, 311;
    Error_BadClassDecl                                , CError, 312;
    Error_BadInductiveParam                           , CFatal, 313;
    Error_FieldShadow                                 , CFatal, 314;
    Error_UnexpectedDM4FType                          , CFatal, 315;
    Fatal_EffectAbbreviationResultTypeMismatch        , CFatal, 316;
    Error_AlreadyCachedAssertionFailure               , CFatal, 317;
    Error_MustEraseMissing                            , CWarning, 318;
    Warning_EffectfulArgumentToErasedFunction         , CWarning, 319;
    Fatal_EmptySurfaceLet                             , CFatal, 320;
    Warning_UnexpectedCheckedFile                     , CWarning, 321;
    Fatal_ExtractionUnsupported                       , CFatal, 322;
    Warning_SMTErrorReason                            , CWarning, 323;
    Warning_CoercionNotFound                          , CWarning, 324;
    Error_QuakeFailed                                 , CError, 325;
    Error_IllSMTPat                                   , CError, 326;
    Error_IllScopedTerm                               , CError, 327;
    Warning_UnusedLetRec                              , CWarning, 328;
    Fatal_Effects_Ordering_Coherence                  , CError, 329;
    Warning_BleedingEdge_Feature                      , CWarning, 330;
    Warning_IgnoredBinding                            , CWarning, 331;
    Warning_CouldNotReadHints                         , CWarning, 333;
    Fatal_BadUvar                                     , CFatal,   334;
    Warning_WarnOnUse                                 , CSilent,  335;
    Warning_DeprecatedAttributeSyntax                 , CSilent,  336;
    Warning_DeprecatedGeneric                         , CWarning, 337;
    Error_BadSplice                                   , CError, 338;
    Error_UnexpectedUnresolvedUvar                    , CAlwaysError, 339;
    Warning_UnfoldPlugin                              , CWarning, 340;
    Error_LayeredMissingAnnot                         , CAlwaysError, 341;
    Error_CallToErased                                , CError, 342;
    Error_ErasedCtor                                  , CError, 343;
    Error_RemoveUnusedTypeParameter                   , CWarning, 344;
    Warning_NoMagicInFSharp                           , CWarning, 345;
    Error_BadLetOpenRecord                            , CAlwaysError, 346;
    Error_UnexpectedTypeclassInstance                 , CAlwaysError, 347;
    Warning_AmbiguousResolveImplicitsHook             , CWarning, 348;
    Warning_SplitAndRetryQueries                      , CWarning, 349;
    Warning_DeprecatedLightDoNotation                 , CWarning, 350;
    Warning_FailedToCheckInitialTacticGoal            , CSilent,  351;
    Warning_Adhoc_IndexedEffect_Combinator            , CWarning, 352;
    Error_PluginDynlink                               , CError, 353;
    Error_InternalQualifier                           , CAlwaysError, 354;
    ]
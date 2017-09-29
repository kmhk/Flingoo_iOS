//
//  FLMFDetailsViewController.m
//  Flingoo
//
//  Created by Hemal on 11/17/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLMFDetailsViewController.h"
#import "FLDetailSectionOneCell.h"
#import "FLDetailSectionTwoCell.h"
#import "FLDetailSectionThreeCell.h"
#import "FLProfileViewController.h"
#import "FLUtilUserDefault.h"
#import "FLGlobalSettings.h"
#import "Config.h"

@interface FLMFDetailsViewController ()
@property(nonatomic,strong) FLOtherProfile *profileObj;
@property(nonatomic,strong) NSString *profile;

@end
#define NO_OF_SECTION 3
#define SECTION_ONE_CELLS 1
#define SECTION_TWO_CELLS 16
#define SECTION_THREE_CELLS 9

@implementation FLMFDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profile:(NSString *)profile withProfileObj:(FLOtherProfile *)profileObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (profileObj!=nil && [profileObj isKindOfClass:[FLOtherProfile class]]) {
            self.profileObj=profileObj;
        }
        self.profile=profile;
        myDetailArr=[[NSMutableArray alloc] init];
        
        if ([self.profile isEqualToString:MY_PROFILE]) {
            self.navigationItem.title = @"Details";
            self.tabBarItem.title = @"Details";
            self.tabBarItem.image = [UIImage imageNamed:@"details_tabbar.png"];
        }
        else
        {
            self.navigationItem.title =self.profileObj.full_name;
        }
        
    }
    return self;
}

-(int)indexForGivenAnswer:(NSString *)answerStr withAnswerKeyArr:(NSArray *)answerKeyArr
{
    for (int x=0; x<[answerKeyArr count]; x++)
    {
        if ([answerStr isEqualToString:[answerKeyArr objectAtIndex:x]]) {
            return x;
        }
    }
    return (-1);
}


-(void)setDetailsObjValues:(id)current_profileObj
{

    if ([self.profile isEqualToString:OTHER_PROFILE])
    {
      FLOtherProfile *profileObj=(FLOtherProfile *)current_profileObj;
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Orientation" withAnswers:[NSArray arrayWithObjects:@"Private",@"Heterosexual",@"Homesexual",@"Bisexual", nil]  withAnswersKey:[NSArray arrayWithObjects:@"private",@"heterosexual",@"homesexual",@"bisexual", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.orientation withAnswerKeyArr:[NSArray arrayWithObjects:@"private",@"heterosexual",@"homesexual",@"bisexual", nil]] withQuestionKey:@"orientation"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Height" withAnswers:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil] withAnswersKey:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil] withUserAnswer:[self indexForGivenAnswer:[NSString stringWithFormat:@"%@",profileObj.height] withAnswerKeyArr:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil]] withQuestionKey:@"height"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Weight" withAnswers:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil] withAnswersKey:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil] withUserAnswer:[self indexForGivenAnswer:[NSString stringWithFormat:@"%@",profileObj.weight] withAnswerKeyArr:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil]] withQuestionKey:@"weight"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Figure" withAnswers:[NSArray arrayWithObjects:@"Slim",@"Average",@"Athletic",@"Muscular",@"A little more to love",@"Overweight", nil] withAnswersKey:[NSArray arrayWithObjects:@"slim",@"average",@"athletic",@"muscular",@"a_little_more_to_love",@"overweight", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.figure withAnswerKeyArr:[NSArray arrayWithObjects:@"slim",@"average",@"athletic",@"muscular",@"a_little_more_to_love",@"overweight", nil]] withQuestionKey:@"figure"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Hair color" withAnswers:[NSArray arrayWithObjects:@"Black",@"Brown",@"Red",@"Blond",@"Grey",@"Other", nil] withAnswersKey:[NSArray arrayWithObjects:@"black",@"brown",@"red",@"blond",@"grey",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.hair_color withAnswerKeyArr:[NSArray arrayWithObjects:@"black",@"brown",@"red",@"blond",@"grey",@"other", nil]] withQuestionKey:@"hair_color"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Hair length" withAnswers:[NSArray arrayWithObjects:@"Bald",@"Very short",@"Chin length",@"Shoulder length",@"Long",@"Very long",nil] withAnswersKey:[NSArray arrayWithObjects:@"bald",@"very_short",@"chin-length",@"shoulder-length",@"long",@"very_long",nil] withUserAnswer:[self indexForGivenAnswer:profileObj.hair_length withAnswerKeyArr:[NSArray arrayWithObjects:@"bald",@"very_short",@"chin-length",@"shoulder-length",@"long",@"very_long",nil]] withQuestionKey:@"hair_length"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Eye color" withAnswers:[NSArray arrayWithObjects:@"Blue",@"Blue green",@"Green",@"Grey",@"Greyish blue",@"Grey green",@"Brown",@"Black",@"Other", nil] withAnswersKey:[NSArray arrayWithObjects:@"blue",@"blue-green",@"green",@"grey",@"greyish-blue",@"grey-green",@"brown",@"black",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.eye_color withAnswerKeyArr:[NSArray arrayWithObjects:@"blue",@"blue-green",@"green",@"grey",@"greyish-blue",@"grey-green",@"brown",@"black",@"other", nil]] withQuestionKey:@"eye_color"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Body art" withAnswers:[NSArray arrayWithObjects:@"Both?????",@"Piercing",@"Tattoo",@"None", nil]  withAnswersKey:[NSArray arrayWithObjects:@"both?????",@"piercing",@"tattoo",@"none", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.body_art withAnswerKeyArr:[NSArray arrayWithObjects:@"both?????",@"piercing",@"tattoo",@"none", nil]] withQuestionKey:@"body_art"]];
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Smoker" withAnswers:[NSArray arrayWithObjects:@"Non smoker",@"Ex smoker",@"Occational smoker",@"Smoker", nil] withAnswersKey:[NSArray arrayWithObjects:@"non-smoker",@"ex-smoker",@"occational_smoker",@"smoker", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.smoker withAnswerKeyArr:[NSArray arrayWithObjects:@"non-smoker",@"ex-smoker",@"occational_smoker",@"smoker", nil]] withQuestionKey:@"smoker"]];
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Ethnicity" withAnswers:[NSArray arrayWithObjects:@"European",@"Arabian",@"Asian",@"	African",@"Indian",@"Latin american",@"Mixed",@"Other", nil] withAnswersKey:[NSArray arrayWithObjects:@"european",@"arabian",@"asian",@"	african",@"indian",@"latin_american",@"mixed",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.ethnicity withAnswerKeyArr:[NSArray arrayWithObjects:@"european",@"arabian",@"asian",@"	african",@"indian",@"latin_american",@"mixed",@"other", nil]] withQuestionKey:@"ethnicity"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Religion" withAnswers:[NSArray arrayWithObjects:@"Not religiuos",@"Atheist",@"Spiritual",@"Buddhist",@"Muslim",@"Hindu",@"Jewish",@"Christian",@"Other", nil]  withAnswersKey:[NSArray arrayWithObjects:@"not_religiuos",@"atheist",@"spiritual",@"buddhist",@"muslim",@"hindu",@"jewish",@"christian",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.religion withAnswerKeyArr:[NSArray arrayWithObjects:@"not_religiuos",@"atheist",@"spiritual",@"buddhist",@"muslim",@"hindu",@"jewish",@"christian",@"other", nil]] withQuestionKey:@"religion"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Children" withAnswers:[NSArray arrayWithObjects:@"No children",@"Living at home",@"Not at home", nil] withAnswersKey:[NSArray arrayWithObjects:@"no_children",@"living_at_home",@"not_at_home", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.children withAnswerKeyArr:[NSArray arrayWithObjects:@"no_children",@"living_at_home",@"not_at_home", nil]] withQuestionKey:@"children"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Living situation" withAnswers:[NSArray arrayWithObjects:@"Alone",@"With parents",@"With a partner",@"Student residence",@"Shared apartment", nil] withAnswersKey:[NSArray arrayWithObjects:@"alone",@"with_parents",@"with_a_partner",@"student_residence",@"shared_apartment", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.living_situation withAnswerKeyArr:[NSArray arrayWithObjects:@"alone",@"with_parents",@"with_a_partner",@"student_residence",@"shared_apartment", nil]] withQuestionKey:@"living_situation"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Education" withAnswers:[NSArray arrayWithObjects:@"Not finished",@"Company based training",@"Secondary school",@"High school diploma",@"College/University",@"University Degree", nil] withAnswersKey:[NSArray arrayWithObjects:@"not_finished",@"company-based_training",@"secondary_school",@"high-school_diploma",@"college/university",@"university_degree", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.training withAnswerKeyArr:[NSArray arrayWithObjects:@"not_finished",@"company-based_training",@"secondary_school",@"high-school_diploma",@"college/university",@"university_degree", nil]] withQuestionKey:@"training"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Profession" withAnswers:[NSArray arrayWithObjects:@"Job seeker",@"Trainee",@"Employee",@"Civil servant",@"Home maker",@"Pensioner",@"Self employed",@"Pupil",@"Student", nil] withAnswersKey:[NSArray arrayWithObjects:@"job_seeker",@"trainee",@"employee",@"civil-servant",@"home_maker",@"pensioner",@"self-employed",@"pupil",@"student", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.profession withAnswerKeyArr:[NSArray arrayWithObjects:@"job_seeker",@"trainee",@"employee",@"civil-servant",@"home_maker",@"pensioner",@"self-employed",@"pupil",@"student", nil]] withQuestionKey:@"profession"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Income" withAnswers:[NSArray arrayWithObjects:@"No income",@"Below average",@"Average",@"Above average", nil] withAnswersKey:[NSArray arrayWithObjects:@"no_income",@"below_average",@"average",@"above_average", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.income withAnswerKeyArr:[NSArray arrayWithObjects:@"no_income",@"below_average",@"average",@"above_average", nil]] withQuestionKey:@"income"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:@"Relationship status" withAnswers:[NSArray arrayWithObjects:@"Single",@"Romance",@"Open relationship",@"In a relationship",@"Married",@"It’s complicated", nil] withAnswersKey:[NSArray arrayWithObjects:@"single",@"romance",@"open_relationship",@"in_a_relationship",@"married",@"it’s_complicated", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.relationship_status withAnswerKeyArr:[NSArray arrayWithObjects:@"single",@"romance",@"open_relationship",@"in_a_relationship",@"married",@"it’s_complicated", nil]] withQuestionKey:@"relationship_status"]];
        
        //<##>
        
        ///////////////////////////////////////////////////////////////////////////////////
        
        for (int x=0 ; x<[[FLGlobalSettings sharedInstance].interviewQuestionListArr count];x++)
        {
              FLMyDetail *myDetailObj_globle=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:x];
            
            for (int y=0 ; y<[profileObj.interviewQuestionsArr count];y++)
            {
              
                FLMyDetail *myDetailObj=(FLMyDetail *)[profileObj.interviewQuestionsArr objectAtIndex:y];
                
    
                 if ([[NSString stringWithFormat:@"%@",myDetailObj_globle.questionKey] isEqualToString:[NSString stringWithFormat:@"%@",myDetailObj.questionKey] ])
                {
                     NSLog(@"//////////////////////////////////////");
                    NSLog(@"myDetailObj_globle.questionKey %@",myDetailObj_globle.questionKey);
                    NSLog(@"myDetailObj %@",myDetailObj.questionKey);
                     NSLog(@"//////////////////////////////////////");
                    
                    if ([[NSString stringWithFormat:@"%@",myDetailObj_globle.questionKey]  isEqualToString:@"1"])
                    {
                    
                        [myDetailArr addObject:[self addQuestionObj:@"I'm Looking For" withQuestion:myDetailObj_globle.question withAnswers:myDetailObj_globle.answers_arr withAnswersKey:myDetailObj_globle.answers_key_arr withUserAnswer:myDetailObj.user_answer_index withQuestionKey:myDetailObj.questionKey]];
                    }
                    else
                    {
                       
                        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle.question withAnswers:myDetailObj_globle.answers_arr withAnswersKey:myDetailObj_globle.answers_key_arr withUserAnswer:myDetailObj.user_answer_index withQuestionKey:myDetailObj.questionKey]];
                        
                    }
                   
                                
                    break;
                }
            }
        }
        
        
        
        
        
    
        
        
   
        
        
      
        
        
//        FLMyDetail *myDetailObj_globle_3=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:3];
//        FLMyDetail *myDetailObj_3=[profileObj.interviewQuestionsArr objectAtIndex:3];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle_3.question withAnswers:myDetailObj_globle_3.answers_arr withAnswersKey:myDetailObj_globle_3.answers_key_arr withUserAnswer:myDetailObj_3.user_answer_index withQuestionKey:myDetailObj_3.questionKey]];
//        
//        
//        FLMyDetail *myDetailObj_globle_4=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:4];
//        FLMyDetail *myDetailObj_4=[profileObj.interviewQuestionsArr objectAtIndex:4];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle_4.question withAnswers:myDetailObj_globle_4.answers_arr withAnswersKey:myDetailObj_globle_4.answers_key_arr withUserAnswer:myDetailObj_4.user_answer_index withQuestionKey:myDetailObj_4.questionKey]];
//        
//        
//        FLMyDetail *myDetailObj_globle_5=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:5];
//        FLMyDetail *myDetailObj_5=[profileObj.interviewQuestionsArr objectAtIndex:5];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle_5.question withAnswers:myDetailObj_globle_5.answers_arr withAnswersKey:myDetailObj_globle_5.answers_key_arr withUserAnswer:myDetailObj_5.user_answer_index withQuestionKey:myDetailObj_5.questionKey]];
//        
//        
//        FLMyDetail *myDetailObj_globle_6=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:6];
//        FLMyDetail *myDetailObj_6=[profileObj.interviewQuestionsArr objectAtIndex:6];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle_6.question withAnswers:myDetailObj_globle_6.answers_arr withAnswersKey:myDetailObj_globle_6.answers_key_arr withUserAnswer:myDetailObj_6.user_answer_index withQuestionKey:myDetailObj_6.questionKey]];
//        
//        
//        FLMyDetail *myDetailObj_globle_7=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:7];
//        FLMyDetail *myDetailObj_7=[profileObj.interviewQuestionsArr objectAtIndex:7];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle_7.question withAnswers:myDetailObj_globle_7.answers_arr withAnswersKey:myDetailObj_globle_7.answers_key_arr withUserAnswer:myDetailObj_7.user_answer_index withQuestionKey:myDetailObj_7.questionKey]];
//        
//        
//        FLMyDetail *myDetailObj_globle_8=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:8];
//        FLMyDetail *myDetailObj_8=[profileObj.interviewQuestionsArr objectAtIndex:8];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle_8.question withAnswers:myDetailObj_globle_8.answers_arr withAnswersKey:myDetailObj_globle_8.answers_key_arr withUserAnswer:myDetailObj_8.user_answer_index withQuestionKey:myDetailObj_8.questionKey]];
        
    }
    else
    {

        
         FLProfile *profileObj=(FLProfile *)current_profileObj;
        
        
        
        
       
            FLMyDetail *myDetailObj_globle=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:0];//set 0 index for first index of array
            
            for (int y=0 ; y<[profileObj.interviewQuestionsArr count];y++)
            {
                FLMyDetail *myDetailObj=(FLMyDetail *)[profileObj.interviewQuestionsArr objectAtIndex:y];
                                
                if ([[NSString stringWithFormat:@"%@",myDetailObj_globle.questionKey] isEqualToString:[NSString stringWithFormat:@"%@",myDetailObj.questionKey] ])
                {
                    if ([[NSString stringWithFormat:@"%@",myDetailObj_globle.questionKey]  isEqualToString:@"1"])
                    {
                        
                        [myDetailArr addObject:[self addQuestionObj:@"I'm Looking For" withQuestion:myDetailObj_globle.question withAnswers:myDetailObj_globle.answers_arr withAnswersKey:myDetailObj_globle.answers_key_arr withUserAnswer:myDetailObj.user_answer_index withQuestionKey:myDetailObj.questionKey]];
                    }
             
                    break;
                }
            }
            
        

        
        
//        FLMyDetail *myDetailObj_globle_0=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:0];
//        FLMyDetail *myDetailObj_0=[profileObj.interviewQuestionsArr objectAtIndex:0];
//        
//        [myDetailArr addObject:[self addQuestionObj:@"I'm Looking For" withQuestion:myDetailObj_globle_0.question withAnswers:myDetailObj_globle_0.answers_arr withAnswersKey:myDetailObj_globle_0.answers_key_arr withUserAnswer:myDetailObj_0.user_answer_index withQuestionKey:myDetailObj_0.questionKey]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Orientation" withAnswers:[NSArray arrayWithObjects:@"Private",@"Heterosexual",@"Homesexual",@"Bisexual", nil]  withAnswersKey:[NSArray arrayWithObjects:@"private",@"heterosexual",@"homesexual",@"bisexual", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.orientation withAnswerKeyArr:[NSArray arrayWithObjects:@"private",@"heterosexual",@"homesexual",@"bisexual", nil]] withQuestionKey:@"orientation"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Height" withAnswers:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil] withAnswersKey:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil] withUserAnswer:[self indexForGivenAnswer:[NSString stringWithFormat:@"%@",profileObj.height] withAnswerKeyArr:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil]] withQuestionKey:@"height"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Weight" withAnswers:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil] withAnswersKey:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil] withUserAnswer:[self indexForGivenAnswer:[NSString stringWithFormat:@"%@",profileObj.weight] withAnswerKeyArr:[NSArray arrayWithObjects:@"15",@"16",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil]] withQuestionKey:@"weight"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Figure" withAnswers:[NSArray arrayWithObjects:@"Slim",@"Average",@"Athletic",@"Muscular",@"A little more to love",@"Overweight", nil] withAnswersKey:[NSArray arrayWithObjects:@"slim",@"average",@"athletic",@"muscular",@"a_little_more_to_love",@"overweight", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.figure withAnswerKeyArr:[NSArray arrayWithObjects:@"slim",@"average",@"athletic",@"muscular",@"a_little_more_to_love",@"overweight", nil]] withQuestionKey:@"figure"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Hair color" withAnswers:[NSArray arrayWithObjects:@"Black",@"Brown",@"Red",@"Blond",@"Grey",@"Other", nil] withAnswersKey:[NSArray arrayWithObjects:@"black",@"brown",@"red",@"blond",@"grey",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.hair_color withAnswerKeyArr:[NSArray arrayWithObjects:@"black",@"brown",@"red",@"blond",@"grey",@"other", nil]] withQuestionKey:@"hair_color"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Hair length" withAnswers:[NSArray arrayWithObjects:@"Bald",@"Very short",@"Chin length",@"Shoulder length",@"Long",@"Very long",nil] withAnswersKey:[NSArray arrayWithObjects:@"bald",@"very_short",@"chin-length",@"shoulder-length",@"long",@"very_long",nil] withUserAnswer:[self indexForGivenAnswer:profileObj.hair_length withAnswerKeyArr:[NSArray arrayWithObjects:@"bald",@"very_short",@"chin-length",@"shoulder-length",@"long",@"very_long",nil]] withQuestionKey:@"hair_length"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Eye color" withAnswers:[NSArray arrayWithObjects:@"Blue",@"Blue green",@"Green",@"Grey",@"Greyish blue",@"Grey green",@"Brown",@"Black",@"Other", nil] withAnswersKey:[NSArray arrayWithObjects:@"blue",@"blue-green",@"green",@"grey",@"greyish-blue",@"grey-green",@"brown",@"black",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.eye_color withAnswerKeyArr:[NSArray arrayWithObjects:@"blue",@"blue-green",@"green",@"grey",@"greyish-blue",@"grey-green",@"brown",@"black",@"other", nil]] withQuestionKey:@"eye_color"]];
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Body art" withAnswers:[NSArray arrayWithObjects:@"Both?????",@"Piercing",@"Tattoo",@"None", nil]  withAnswersKey:[NSArray arrayWithObjects:@"both?????",@"piercing",@"tattoo",@"none", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.body_art withAnswerKeyArr:[NSArray arrayWithObjects:@"both?????",@"piercing",@"tattoo",@"none", nil]] withQuestionKey:@"body_art"]];
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Smoker" withAnswers:[NSArray arrayWithObjects:@"Non smoker",@"Ex smoker",@"Occational smoker",@"Smoker", nil] withAnswersKey:[NSArray arrayWithObjects:@"non-smoker",@"ex-smoker",@"occational_smoker",@"smoker", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.smoker withAnswerKeyArr:[NSArray arrayWithObjects:@"non-smoker",@"ex-smoker",@"occational_smoker",@"smoker", nil]] withQuestionKey:@"smoker"]];
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Ethnicity" withAnswers:[NSArray arrayWithObjects:@"European",@"Arabian",@"Asian",@"	African",@"Indian",@"Latin american",@"Mixed",@"Other", nil] withAnswersKey:[NSArray arrayWithObjects:@"european",@"arabian",@"asian",@"	african",@"indian",@"latin_american",@"mixed",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.ethnicity withAnswerKeyArr:[NSArray arrayWithObjects:@"european",@"arabian",@"asian",@"	african",@"indian",@"latin_american",@"mixed",@"other", nil]] withQuestionKey:@"ethnicity"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Religion" withAnswers:[NSArray arrayWithObjects:@"Not religiuos",@"Atheist",@"Spiritual",@"Buddhist",@"Muslim",@"Hindu",@"Jewish",@"Christian",@"Other", nil]  withAnswersKey:[NSArray arrayWithObjects:@"not_religiuos",@"atheist",@"spiritual",@"buddhist",@"muslim",@"hindu",@"jewish",@"christian",@"other", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.religion withAnswerKeyArr:[NSArray arrayWithObjects:@"not_religiuos",@"atheist",@"spiritual",@"buddhist",@"muslim",@"hindu",@"jewish",@"christian",@"other", nil]] withQuestionKey:@"religion"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Children" withAnswers:[NSArray arrayWithObjects:@"No children",@"Living at home",@"Not at home", nil] withAnswersKey:[NSArray arrayWithObjects:@"no_children",@"living_at_home",@"not_at_home", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.children withAnswerKeyArr:[NSArray arrayWithObjects:@"no_children",@"living_at_home",@"not_at_home", nil]] withQuestionKey:@"children"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Living situation" withAnswers:[NSArray arrayWithObjects:@"Alone",@"With parents",@"With a partner",@"Student residence",@"Shared apartment", nil] withAnswersKey:[NSArray arrayWithObjects:@"alone",@"with_parents",@"with_a_partner",@"student_residence",@"shared_apartment", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.living_situation withAnswerKeyArr:[NSArray arrayWithObjects:@"alone",@"with_parents",@"with_a_partner",@"student_residence",@"shared_apartment", nil]] withQuestionKey:@"living_situation"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Education" withAnswers:[NSArray arrayWithObjects:@"Not finished",@"Company based training",@"Secondary school",@"High school diploma",@"College/University",@"University Degree", nil] withAnswersKey:[NSArray arrayWithObjects:@"not_finished",@"company-based_training",@"secondary_school",@"high-school_diploma",@"college/university",@"university_degree", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.training withAnswerKeyArr:[NSArray arrayWithObjects:@"not_finished",@"company-based_training",@"secondary_school",@"high-school_diploma",@"college/university",@"university_degree", nil]] withQuestionKey:@"training"]];
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Profession" withAnswers:[NSArray arrayWithObjects:@"Job seeker",@"Trainee",@"Employee",@"Civil servant",@"Home maker",@"Pensioner",@"Self employed",@"Pupil",@"Student", nil] withAnswersKey:[NSArray arrayWithObjects:@"job_seeker",@"trainee",@"employee",@"civil-servant",@"home_maker",@"pensioner",@"self-employed",@"pupil",@"student", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.profession withAnswerKeyArr:[NSArray arrayWithObjects:@"job_seeker",@"trainee",@"employee",@"civil-servant",@"home_maker",@"pensioner",@"self-employed",@"pupil",@"student", nil]] withQuestionKey:@"profession"]];
        
        
        
        
        [myDetailArr addObject:[self addQuestionObj:@"About me" withQuestion:@"Income" withAnswers:[NSArray arrayWithObjects:@"No income",@"Below average",@"Average",@"Above average", nil] withAnswersKey:[NSArray arrayWithObjects:@"no_income",@"below_average",@"average",@"above_average", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.income withAnswerKeyArr:[NSArray arrayWithObjects:@"no_income",@"below_average",@"average",@"above_average", nil]]withQuestionKey:@"income"]];
         
         
         
         
         [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:@"Relationship status" withAnswers:[NSArray arrayWithObjects:@"Single",@"Romance",@"Open relationship",@"In a relationship",@"Married",@"It’s complicated", nil] withAnswersKey:[NSArray arrayWithObjects:@"single",@"romance",@"open_relationship",@"in_a_relationship",@"married",@"it’s_complicated", nil] withUserAnswer:[self indexForGivenAnswer:profileObj.relationship_status withAnswerKeyArr:[NSArray arrayWithObjects:@"single",@"romance",@"open_relationship",@"in_a_relationship",@"married",@"it’s_complicated", nil]] withQuestionKey:@"relationship_status"]];
        ///////////////////////////////////////////////////////////////////////////////////
    

    
        
        for (int x=0 ; x<[[FLGlobalSettings sharedInstance].interviewQuestionListArr count];x++)
        {
            FLMyDetail *myDetailObj_globle=[[FLGlobalSettings sharedInstance].interviewQuestionListArr objectAtIndex:x];
            
            for (int y=0 ; y<[profileObj.interviewQuestionsArr count];y++)
            {
                
                FLMyDetail *myDetailObj=(FLMyDetail *)[profileObj.interviewQuestionsArr objectAtIndex:y];
                
                
                if ([[NSString stringWithFormat:@"%@",myDetailObj_globle.questionKey] isEqualToString:[NSString stringWithFormat:@"%@",myDetailObj.questionKey] ])
                {
                    NSLog(@"//////////////////////////////////////");
                    NSLog(@"myDetailObj_globle.questionKey %@",myDetailObj_globle.questionKey);
                    NSLog(@"myDetailObj %@",myDetailObj.questionKey);
                    NSLog(@"myDetailObj_globle.answers_arr) %@",myDetailObj_globle.answers_arr);
                    NSLog(@"//////////////////////////////////////");
                    
                    if (![[NSString stringWithFormat:@"%@",myDetailObj_globle.questionKey]  isEqualToString:@"1"])
                    {
                        
                        [myDetailArr addObject:[self addQuestionObj:@"Interview" withQuestion:myDetailObj_globle.question withAnswers:myDetailObj_globle.answers_arr withAnswersKey:myDetailObj_globle.answers_key_arr withUserAnswer:myDetailObj.user_answer_index withQuestionKey:myDetailObj.questionKey]];
                    }
                
                }
            }
           
        }
    
//for (int tt=0; tt<[myDetailArr count]; tt++) {
//    FLMyDetail *Obj=(FLMyDetail *)[myDetailArr objectAtIndex:tt];
//    
//    NSLog(@"tttttt Obj.questionKey %@",Obj.questionKey);
//    NSLog(@"tttttt Obj.user_answer_index %d",Obj.user_answer_index);
//}


    }




}


#pragma mark -
#pragma mark - view lifefycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.profile isEqualToString:MY_PROFILE]) {
        tblMyDetails.hidden=YES;
    }
    
//    if ([viewTitleFrom isEqualToString:@"Details"])
//    {
//        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
//        [webService currentUserProfileDetail:self];
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self.profile isEqualToString:OTHER_PROFILE]) {
        self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(backClicked)];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
    
    if ([self.profile isEqualToString:MY_PROFILE] && [myDetailArr count]==0)
    {
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Loading...";
        HUD.square = YES;
        [HUD show:YES];
       
        
        if ([FLGlobalSettings sharedInstance].interviewQuestionListArr==nil || [[FLGlobalSettings sharedInstance].interviewQuestionListArr count]==0)
        {
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            [webServiceApi interviewQuestionList:self];
        }else
        {
            FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
            //        [webService currentUserProfileDetail:self];
            [webService currentUser:self];
        }
        
    }
    else if([self.profile isEqualToString:OTHER_PROFILE] && [myDetailArr count]==0)
    {
        
        if ([FLGlobalSettings sharedInstance].interviewQuestionListArr==nil || [[FLGlobalSettings sharedInstance].interviewQuestionListArr count]==0)
        {
            tblMyDetails.hidden=YES;
            HUD=[[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            // Set the hud to display with a color
            //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
            HUD.delegate = self;
            HUD.labelText = @"Loading...";
            HUD.square = YES;
            [HUD show:YES];
            
            FLWebServiceApi *webServiceApi=[[FLWebServiceApi alloc] init];
            [webServiceApi interviewQuestionList:self];
        }
        else
        {
            [self setDetailsObjValues:self.profileObj];
            NSLog(@"myDetailArr %@",myDetailArr);
            [tblMyDetails reloadData];
        }

    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    interviewQuesSubmitArr=[[NSMutableArray alloc] init];
    //***hemalasankas have to fix
    if ([self.profile isEqualToString:MY_PROFILE])
    {
    FLUserDetail *userDetailObj=[[FLUserDetail alloc] init];
    for (id obj in myDetailArr)
    {
        FLMyDetail *myDetail=(FLMyDetail *)obj;
        NSLog(@"myDetail.questionKey %@",myDetail.questionKey);

        if ([[NSString stringWithFormat:@"%@",myDetail.questionKey] isEqualToString:@"orientation"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.orientation=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"height"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.height=[NSNumber numberWithInteger: [[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index] integerValue]];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"figure"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.figure=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"hair_color"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.hair_color=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"hair_length"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.hair_length=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"eye_color"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.eye_color=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"body_art"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.body_art=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"smoker"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.smoker=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"ethnicity"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.ethnicity=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"religion"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.religion=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"children"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.children=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"living_situation"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.living_situation=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"training"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.training=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"profession"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.profession=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"income"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.income=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"weight"] &&  myDetail.user_answer_index!=(-1) ) {
            
            userDetailObj.weight=[NSNumber numberWithInteger:[[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index] integerValue]];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"relationship_status"] &&  myDetail.user_answer_index!=(-1)) {
            userDetailObj.relationship_status=[myDetail.answers_key_arr objectAtIndex:myDetail.user_answer_index];
        }
        //////
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"1"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"2"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"3"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"4"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"5"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"6"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"7"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"8"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
        else if ([[NSString stringWithFormat:@"%@",myDetail.questionKey]  isEqualToString:@"9"] &&  myDetail.user_answer_index!=(-1)) {
            [interviewQuesSubmitArr addObject:myDetail];
        }
       
    }
        userDetailObj.gender=[FLGlobalSettings sharedInstance].current_user_profile.gender;
        userDetailObj.looking_for=[FLGlobalSettings sharedInstance].current_user_profile.looking_for;
        userDetailObj.who_looking_for=[FLGlobalSettings sharedInstance].current_user_profile.who_looking_for;
        //hemalasankas**
//        userDetailObj.mobile_number=@"777777";
//        userDetailObj.mobile_phone
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        // Set the hud to display with a color
        //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        HUD.delegate = self;
        HUD.labelText = @"Loading...";
        HUD.square = YES;
        [HUD show:YES];
        
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    [webService profileUpdate:self withUserData:userDetailObj];
    }
    
}


-(void)backClicked
{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - webservice Api response
//<##>
-(void)currentUserResult:(FLProfile *)me
{
    NSLog(@"profileObjArr %@",me.full_name);
    [FLGlobalSettings sharedInstance].current_user_profile=me;  
    
    
    [self setDetailsObjValues:me];
    [tblMyDetails reloadData];
    [HUD hide:YES];
    tblMyDetails.hidden=NO;
}

-(void)interviewQuestionsResult:(NSMutableArray *)questionsArr
{
    [FLGlobalSettings sharedInstance].interviewQuestionListArr=[[NSMutableArray alloc] init];
    [FLGlobalSettings sharedInstance].interviewQuestionListArr=questionsArr;
    
    for(id test in questionsArr)
    {
        FLMyDetail *detailObj=[[FLMyDetail alloc] init];
        detailObj=test;
        NSLog(@"detailObj.question %@",detailObj.question);
        for(id test1 in detailObj.answers_arr)
        {
            NSLog(@"detailObj.answers_arr %@",test1);
        }
    }
    //<##>
    if ([self.profile isEqualToString:MY_PROFILE])
    {
        FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
        [webService currentUser:self];
    }
    else
    {
        [HUD hide:YES];
        tblMyDetails.hidden=NO;
        [self setDetailsObjValues:self.profileObj];
        NSLog(@"myDetailArr %@",myDetailArr);
        [tblMyDetails reloadData];
    }
}


-(void)profileUpdateResult:(NSString *)msg
{
    NSLog(@"msg %@",msg);
    if ([interviewQuesSubmitArr count]==0) {
        [HUD hide:YES];
    }
    else
    {
        FLWebServiceApi *webServiceAPI=[[FLWebServiceApi alloc] init];
        [webServiceAPI interviewQuestionUpdate:self withQuestionObj:[interviewQuesSubmitArr objectAtIndex:0]];
    
    }
    
}

-(void)interviewQuestionUpdateResult:(FLMyDetail *)myDetailObj
{
    [interviewQuesSubmitArr removeObject:myDetailObj];
    if ([interviewQuesSubmitArr count]==0)
    {
        [HUD hide:YES];
    }
    else
    {
        FLWebServiceApi *webServiceAPI=[[FLWebServiceApi alloc] init];
        [webServiceAPI interviewQuestionUpdate:self withQuestionObj:[interviewQuesSubmitArr objectAtIndex:0]];
    }

}

#pragma mark -
#pragma mark - webservice Api Fail

-(void)unknownFailureCall
{
    [self showValidationAlert:NSLocalizedString(@"unknown_error", nil)];
    [HUD hide:YES];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [self showValidationAlert:errorMsg];
    [HUD hide:YES];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark - Other method



-(FLMyDetail *)addQuestionObj:(NSString *)header withQuestion:(NSString *)question withAnswers:(NSArray *)answersArr withAnswersKey:(NSArray *)answerKeyArr withUserAnswer:(int)userAnswerIndex withQuestionKey:(NSString *)questionKey
{
    FLMyDetail *myDetailObj=[[FLMyDetail alloc] init];
    myDetailObj.header=header;
    myDetailObj.question=question;
    myDetailObj.answers_key_arr=answerKeyArr;
    myDetailObj.answers_arr=answersArr;
    myDetailObj.user_answer_index=userAnswerIndex;
    myDetailObj.questionKey=questionKey;
    return myDetailObj;
}

-(FLMyDetail *)getDetailsObject:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return [myDetailArr objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==1) {
        return [myDetailArr objectAtIndex:(indexPath.row+SECTION_ONE_CELLS)];
    }
    else
    {
        return [myDetailArr objectAtIndex:(indexPath.row+SECTION_ONE_CELLS+SECTION_TWO_CELLS)];
    }
    
}

#pragma mark -
#pragma mark - UITable view data source


// Customize the number of rows in the table view.
-(NSInteger)tableView:(UITableView *)tstable numberOfRowsInSection:(NSInteger)section
{
    if ([myDetailArr count]>0) {
    if (section==0)
    {
        return SECTION_ONE_CELLS;
    }
    else if(section==1)
    {
        return SECTION_TWO_CELLS;
    }
    else if(section==2)
    {
        return SECTION_THREE_CELLS;
    }
    }
    return 0;
}

// Returns the number of section in a table view
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return NO_OF_SECTION;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
////    if (section==0) {
////        return @"I'm Looking For";
////    }
////    else if(section==1)
////    {
////        return @"About me";
////    }
////    else
////    {
////        return @"Interview";
////    }
//    return @"";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(10, 0, 290, 44)];
    
//    titleLabel.text = @"<Title string here>";
    
    if (section==0) {
        titleLabel.text= @"I'm Looking For";
    }
    else if(section==1)
    {
        titleLabel.text = @"About me";
    }
    else
    {
        titleLabel.text = @"Interview";
    }
    
    titleLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        
        static NSString *simpleTableIdentifier = @"FLDetailSectionOneCell";
        
        FLDetailSectionOneCell *cell = (FLDetailSectionOneCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FLDetailSectionOneCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        @try {
            
        FLMyDetail *detailObj=[self getDetailsObject:indexPath];
        cell.currentDetailObj=detailObj;
        if (detailObj.user_answer_index!=(-1)) {
             cell.lblUserAnswer.text=[detailObj.answers_arr objectAtIndex:detailObj.user_answer_index];
        }
        if ([self.profile isEqualToString:OTHER_PROFILE])
        {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imgDownArrow.hidden=YES;
        }
        
        }
        @catch (NSException *exception) {
            NSLog(@"exception %@",exception);
        }
        
        return cell;
            
    }
    
    else if (indexPath.section==1)
    {
        static NSString *simpleTableIdentifier = @"FLDetailSectionTwoCell";
        
        FLDetailSectionTwoCell *cell = (FLDetailSectionTwoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FLDetailSectionTwoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        @try {
            
        FLMyDetail *detailObj=[self getDetailsObject:indexPath];
        cell.currentDetailsObject=detailObj;
        cell.lblQuestion.text=detailObj.question;
       
        if (detailObj.user_answer_index!=(-1)) {
            cell.lblUserAnswer.text=[detailObj.answers_arr objectAtIndex:detailObj.user_answer_index];
        }
        if ([self.profile isEqualToString:OTHER_PROFILE])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imgDownArrow.hidden=YES;
        }
        }
        @catch (NSException *exception) {
            NSLog(@"exception %@",exception);
        }
      
        return cell;
    
    }
    else
    {
        static NSString *simpleTableIdentifier = @"FLDetailSectionThreeCell";
        
        FLDetailSectionThreeCell *cell = (FLDetailSectionThreeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FLDetailSectionThreeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        @try {
     
        FLMyDetail *detailObj=[self getDetailsObject:indexPath];
        cell.currentDetailsObj=detailObj;
        cell.lblQuestion.text=detailObj.question;
//        cell.lblUserAnswer.text=detailObj.user_answer;
        
        if (detailObj.user_answer_index!=(-1)) {
            cell.lblUserAnswer.text=[detailObj.answers_arr objectAtIndex:detailObj.user_answer_index];
        }
        
        if ([self.profile isEqualToString:OTHER_PROFILE])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imgDownArrow.hidden=YES;
        }
        }
        @catch (NSException *exception) {
            NSLog(@"exception %@",exception);
        }
      
        return cell;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [myItemsTView reloadData];
//    NSLog(@"indexPath.row %i",indexPath.row);
//	//Get the selected country
//	Item *itemObject = nil;
//    itemObject = [myItemsArray objectAtIndex:indexPath.row];
//    
//    WBBillPreviewViewController *billPreviewViewController;
//    if (IS_IPHONE_5)
//    {
//        //        if (billPreviewViewController!=nil) {
//        //            NSLog(@"billPreviewViewController nil");
//        //            billPreviewViewController=nil;
//        //        }
//        billPreviewViewController= [[WBBillPreviewViewController alloc]initWithNibName:@"WBBillPreviewView_iPhone5" bundle:nil];
//    }
//    else
//    {
//        //        if (billPreviewViewController!=nil) {
//        //            NSLog(@"billPreviewViewController nil");
//        //            billPreviewViewController=nil;
//        //        }
//        billPreviewViewController= [[WBBillPreviewViewController alloc]initWithNibName:@"WBBillPreviewViewController" bundle:nil];
//    }
//    billPreviewViewController.isNewBill=NO;
//    billPreviewViewController.currentItem=itemObject;
//    NSLog(@"itemObject.item_name %@",itemObject.item_name);
//    NSLog(@"itemObject.category.category_name %@",itemObject.category.category_name);
//    searchBarcodeClicked=YES;//when go back from bill preview view prevent to remove data
//    [self.navigationController pushViewController:billPreviewViewController animated:YES];
    if (![self.profile isEqualToString:OTHER_PROFILE])
    {
    selectedIndexPath=indexPath;
    selectedDetailObj=[self getDetailsObject:indexPath];
    [self createActionSheet];
    [self createUIPickerView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 42;
    }
    else if (indexPath.section==1)
    {
        return 50;
    }
    else
    {
        return 60;
    }
}

#pragma mark -
#pragma mark - ActionSheet creation

- (void)createActionSheet {
   
        if ((IS_IPHONE || IS_IPHONE_5) && actionSheet == nil) {
            // setup actionsheet to contain the UIPicker
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
            
            UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            pickerToolbar.barStyle = UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
            
            NSMutableArray *barItems = [[NSMutableArray alloc] init];
            
            UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
            [barItems addObject:cancelBtn];
            
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [barItems addObject:flexSpace];
            
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
            [barItems addObject:doneBtn];
            
            [pickerToolbar setItems:barItems animated:NO];
            [actionSheet addSubview:pickerToolbar];
//            [actionSheet showInView:self.view];
//            [actionSheet setBounds:CGRectMake(0,0,320, 464)];
        }
        else if(IS_IPAD && popOver==nil)
        {
            UIViewController* popoverContent = [[UIViewController alloc] init];
            
            UIToolbar *toolbr = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(pickerDone:)];
            popoverView = [[UIView alloc] init];   //view
            popoverView.backgroundColor = [UIColor blackColor];
            
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:editButton];
            toolbr.items = items;
            [popoverView addSubview:toolbr];
            ///
            
            ////
            //[popoverView addSubview:theDatePicker];
            
            popoverContent.view = popoverView;
            popOver = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
            //    popOver.delegate=self;
            
            [popOver setPopoverContentSize:CGSizeMake(320, 260) animated:NO];
            
        }

    
}

-(void)createUIPickerView
{
    UIPickerView *chPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
//    UIPickerView *chPicker = [[UIPickerView alloc] init];
    chPicker.dataSource = self;
    chPicker.delegate = self;
    chPicker.showsSelectionIndicator = YES;
    pickerSelectedIndex=0;
    if (IS_IPHONE || IS_IPHONE_5)
	{
    [actionSheet addSubview:chPicker];
     [actionSheet showInView:self.view];
//    pickerSelectedIndex=0;
//    [actionSheet setBounds:CGRectMake(0,0,320, 464)];
   
    
    CGRect newFram=CGRectMake(0,0,320, 464);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [actionSheet setBounds:newFram];
    [UIView commitAnimations];
    }
    else if(IS_IPAD)
    {
        [popoverView addSubview:chPicker];
        
        NSIndexPath *selectedIndexPath11 = [tblMyDetails indexPathForSelectedRow];
         UITableViewCell *selectedCell = [tblMyDetails cellForRowAtIndexPath:selectedIndexPath11];
        
        CGRect frm = selectedCell.frame;
//       frm.origin.y = frm.origin.y ;
    
//          [popOver presentPopoverFromRect:frm inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 [popOver presentPopoverFromRect:frm inView:tblMyDetails permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

    
}

#pragma mark-
#pragma mark- UIPickerViewDelegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [selectedDetailObj.answers_arr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [selectedDetailObj.answers_arr objectAtIndex:row];
}

// Set the width of the component inside the picker
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

// Item picked
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerSelectedIndex=row;
    NSLog(@"pickerSelectedIndex %i",pickerSelectedIndex);
}

- (void)pickerDone:(id)sender
{
    if([selectedDetailObj.answers_arr count]>0){
         NSLog(@"pickerSelectedIndex111 %i",pickerSelectedIndex);
//    [self updateDetails:selectedIndexPath withObject:selectedDetailObj withNewAnswer:[selectedDetailObj.answers_arr objectAtIndex:pickerSelectedIndex]];

    [self updateDetails:selectedIndexPath withObject:selectedDetailObj withNewAnswer:pickerSelectedIndex];
    
    [tblMyDetails reloadData];
}
    if (IS_IPHONE || IS_IPHONE_5)
	{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    actionSheet = nil;
    
    }
    else if(IS_IPAD)
    {
        [popOver dismissPopoverAnimated:YES];
        popOver=nil;
    }
    
}


-(void)pickerCancel:(id)sender
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];    
    actionSheet = nil;
}

-(void)updateDetails:(NSIndexPath *)indexPath withObject:(FLMyDetail *)obj withNewAnswer:(int)new_answer_index
{
    FLMyDetail *newObj=[[FLMyDetail alloc] init];
    newObj.header=obj.header;
    newObj.question=obj.question;
    newObj.answers_key_arr=obj.answers_key_arr;
    newObj.answers_arr=obj.answers_arr;
    newObj.user_answer_index=new_answer_index;
    newObj.questionKey=obj.questionKey;
    
    if (indexPath.section==0)
    {
        [myDetailArr replaceObjectAtIndex:indexPath.row withObject:newObj];
    }
    else if (indexPath.section==1) {
        [myDetailArr replaceObjectAtIndex:(indexPath.row+SECTION_ONE_CELLS) withObject:newObj];
    }
    else
    {
        [myDetailArr replaceObjectAtIndex:(indexPath.row+SECTION_ONE_CELLS+SECTION_TWO_CELLS) withObject:newObj];

    }
}

#pragma mark -
#pragma mark parent view methods

-(void)enableDisableSliderView:(BOOL)enable
{
    tblMyDetails.userInteractionEnabled=enable;
    ([self.tabBarController tabBar]).userInteractionEnabled=enable;
}


@end

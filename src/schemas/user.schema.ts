import { SchemaFactory, Prop, Schema } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type userDocument = user & Document;

@Schema()
export class user {
  @Prop({ required: true })
  userName: string;

  @Prop({ required: true })
  pharmacyName: string;

  @Prop({ required: true })
  pharmacyCode: string;

  @Prop({ required: true })
  mobileNumber: number;

  @Prop({ required: true })
  email: string;

  @Prop({ required: false })
  otp: number;

  @Prop({ required : false })
  password : string;
}

export const userSchema = SchemaFactory.createForClass(user);
